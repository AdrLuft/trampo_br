import 'dart:io';
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/mesages_custom.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/users_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/user_repository_abstract.dart';

class ProfileController extends GetxController {
  final UserRepositoryAbstract _userRepository;

  ProfileController(this._userRepository);

  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Estados reativos para a UI observar
  final RxBool isLoading = true.obs;
  final RxBool isUploadingPhoto = false.obs;
  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Configurar captura global de erros relacionados ao Firebase Storage
    _setupGlobalErrorHandling();

    loadUserData();

    // Executar limpeza de URLs inválidas em background após carregamento
    Future.delayed(const Duration(seconds: 2), () {
      _cleanupInvalidStorageUrls();
    });
  }

  /// Configura captura global de erros do Firebase Storage para evitar exceções não tratadas
  void _setupGlobalErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exception;
      if (exception.toString().contains('firebase_storage') &&
          exception.toString().toLowerCase().contains('object-not-found')) {
        debugPrint(
          '✓ Erro Firebase Storage capturado globalmente e tratado: $exception',
        );
        return; // Não propagar o erro
      }
      // Para outros erros, usar o comportamento padrão
      FlutterError.presentError(details);
    };
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final userEntity = await _userRepository.getLoggedUser();

      // Validar URL da imagem antes de salvar
      if (userEntity.profileImageUrl != null &&
          userEntity.profileImageUrl!.isNotEmpty) {
        final isValidUrl = await _validateFirebaseStorageUrl(
          userEntity.profileImageUrl!,
        );
        if (!isValidUrl) {
          debugPrint(
            'URL de imagem inválida detectada, removendo: ${userEntity.profileImageUrl}',
          );
          // Remove URL inválida do perfil
          final cleanUser = userEntity.copyWith(profileImageUrl: '');
          await _userRepository.updateUser(cleanUser);
          user.value = cleanUser;
        } else {
          user.value = userEntity;
        }
      } else {
        user.value = userEntity;
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
      MessageUtils.showDialogMessage('Erro ao carregar dados', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Valida se uma URL do Firebase Storage é válida e o arquivo existe
  Future<bool> _validateFirebaseStorageUrl(String url) async {
    try {
      if (!url.contains('firebase') || !url.contains('firebasestorage')) {
        debugPrint('URL não é do Firebase Storage: $url');
        return false;
      }

      // Timeout curto para evitar demora desnecessária
      final Reference ref = _storage.refFromURL(url);
      await ref.getMetadata().timeout(
        const Duration(seconds: 3),
        onTimeout:
            () =>
                throw TimeoutException(
                  'Timeout validando URL',
                  const Duration(seconds: 3),
                ),
      );
      debugPrint('URL do Firebase Storage válida: $url');
      return true;
    } on TimeoutException {
      debugPrint('✓ Validação: Timeout ao validar URL: $url');
      return false;
    } on FirebaseException catch (e) {
      // Tratar especificamente erros do Firebase - sem relançar erro
      if (e.code == 'object-not-found') {
        debugPrint('✓ Validação: Arquivo não encontrado (normal): $url');
        return false;
      } else {
        debugPrint('✓ Validação: Erro Firebase (${e.code}): ${e.message}');
        return false;
      }
    } catch (e) {
      debugPrint('✓ Validação: Erro geral (tratado): $url - $e');
      return false;
    }
  }

  /// Executa limpeza de URLs inválidas do Firebase Storage em background
  Future<void> _cleanupInvalidStorageUrls() async {
    try {
      if (user.value?.profileImageUrl == null ||
          user.value!.profileImageUrl!.isEmpty) {
        return;
      }

      final String currentUrl = user.value!.profileImageUrl!;

      // Só valida URLs do Firebase Storage
      if (!currentUrl.contains('firebase') ||
          !currentUrl.contains('firebasestorage')) {
        return;
      }

      debugPrint('Verificando URL de perfil em background: $currentUrl');

      final bool isValid = await _validateFirebaseStorageUrl(currentUrl);

      if (!isValid) {
        debugPrint('URL inválida detectada, removendo automaticamente...');
        // Remove silenciosamente a URL inválida
        final cleanUser = user.value!.copyWith(profileImageUrl: '');
        await _userRepository.updateUser(cleanUser);
        user.value = cleanUser;
        debugPrint('URL inválida removida automaticamente do perfil');
      }
    } catch (e) {
      debugPrint('Erro durante limpeza de URLs (ignorado): $e');
      // Ignora erros na limpeza para não afetar o funcionamento do app
    }
  }

  Future<void> updateUserData({
    required String email,
    required String phone,
    required String address,
    required String name,
  }) async {
    if (user.value == null) return;

    try {
      isLoading.value = true;
      final updatedUser = user.value!.copyWith(
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      await _userRepository.updateUser(updatedUser);
      await loadUserData(); // Recarrega os dados para atualizar a UI
      Get.back(); // Fecha o dialog
      MessageUtils.showDialogMessage(
        'Sucesso',
        'Perfil atualizado com sucesso!',
      );
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao atualizar perfil');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadProfileImage() async {
    try {
      if (user.value == null) return;

      final source = await _showImageSourceDialog();
      if (source == null) return;

      isUploadingPhoto.value = true;

      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final fileName =
          'profile_${user.value!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref('profile_images/$fileName');
      await ref.putFile(File(pickedFile.path));
      final url = await ref.getDownloadURL();

      await _userRepository.updateUser(
        user.value!.copyWith(profileImageUrl: url),
      );
      await loadUserData();

      MessageUtils.showDialogMessage('Sucesso', 'Foto atualizada!');
    } catch (e) {
      MessageUtils.showDialogMessage('Erro', 'Falha no upload: $e');
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource?>(
      AlertDialog(
        title: const Text('Selecionar Foto'),
        content: const Text('Escolha de onde deseja selecionar a foto:'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text('Câmera'),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text('Galeria'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeProfileImage() async {
    try {
      isUploadingPhoto.value = true;

      if (user.value?.profileImageUrl != null &&
          user.value!.profileImageUrl!.contains('firebase')) {
        try {
          await _storage.refFromURL(user.value!.profileImageUrl!).delete();
        } catch (e) {
          // Ignora erro ao deletar
        }
      }

      await _userRepository.updateUser(
        user.value!.copyWith(profileImageUrl: ''),
      );
      await loadUserData();

      MessageUtils.showDialogMessage('Sucesso', 'Foto removida!');
    } catch (e) {
      MessageUtils.showDialogMessage('Erro', 'Falha ao remover: $e');
    } finally {
      isUploadingPhoto.value = false;
    }
  }
}
