import 'dart:io';

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
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      user.value = await _userRepository.getLoggedUser();
    } catch (e) {
      MessageUtils.showDialogMessage('Erro ao carregar dados', e.toString());
    } finally {
      isLoading.value = false;
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
      // Mostrar opções para o usuário escolher
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) return;

      // Selecionar imagem
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      isUploadingPhoto.value = true;

      // Upload para Firebase Storage
      final String downloadUrl = await _uploadImageToStorage(
        File(pickedFile.path),
      );

      // Atualizar usuário com nova URL da foto
      await _updateUserProfileImage(downloadUrl);

      MessageUtils.showDialogMessage(
        'Sucesso',
        'Foto de perfil atualizada com sucesso!',
      );
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao atualizar foto');
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

  Future<String> _uploadImageToStorage(File imageFile) async {
    if (user.value == null) throw Exception('Usuário não encontrado');

    final String fileName =
        'profile_${user.value!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference storageRef = _storage.ref().child(
      'profile_images/$fileName',
    );

    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _updateUserProfileImage(String imageUrl) async {
    if (user.value == null) return;

    final updatedUser = user.value!.copyWith(profileImageUrl: imageUrl);
    await _userRepository.updateUser(updatedUser);
    await loadUserData(); // Recarregar dados para atualizar a UI
  }

  Future<void> removeProfileImage() async {
    try {
      isUploadingPhoto.value = true;

      if (user.value?.profileImageUrl != null &&
          user.value!.profileImageUrl!.isNotEmpty) {
        // Remover do Storage se existir
        try {
          final Reference storageRef = _storage.refFromURL(
            user.value!.profileImageUrl!,
          );
          await storageRef.delete();
        } catch (e) {
          // Ignorar erro se a imagem não existir no storage
        }
      }

      // Atualizar usuário removendo a URL da foto
      await _updateUserProfileImage('');

      MessageUtils.showDialogMessage(
        'Sucesso',
        'Foto de perfil removida com sucesso!',
      );
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao remover foto');
    } finally {
      isUploadingPhoto.value = false;
    }
  }
}
