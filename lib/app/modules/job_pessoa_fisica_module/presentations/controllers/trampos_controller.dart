import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trampos_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class TramposController extends GetxController {
  final ListarTramposPessoaFisicaUsecases _listarTramposUsecases;
  final isLoading = false.obs;
  final TramposRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final minhasVagas = <TramposEntiti>[].obs;
  final vagasSalvas = <Map<String, dynamic>>[].obs;

  GlobalThemeController get themeController =>
      Get.find<GlobalThemeController>();

  TramposController(this._listarTramposUsecases, this._repository);

  @override
  void onInit() {
    super.onInit();
    carregarVagasSalvas();
  }

  //=======================================================================================================================

  Future<void> createTrampo({
    required String descricao,
    required String tipoVaga,
    required String telefone,
    required List<String> exigencias,
    required List<String> valorizados,
    required List<String> beneficios,
  }) async {
    if (descricao.trim().isEmpty) {
      Get.snackbar(
        'Entrada Inválida',
        'A descrição não pode estar vazia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
      );
      return;
    }
    isLoading.value = true;

    try {
      final String userId = auth.currentUser?.uid ?? '';
      final String userEmail = auth.currentUser?.email ?? '';

      if (userId.isEmpty) {
        throw Exception('Usuário não autenticado');
      }
      final novoTrampo = TramposEntiti(
        id: '',
        descricao: descricao.trim(),
        createTrampoNome: '',
        tipoVaga: tipoVaga,
        createDate: DateTime.now().toIso8601String(),
        status: 'Disponivel',
        email: userEmail,
        telefone: telefone.trim(),
        userAddress: '',
        userId: userId,
      );

      await _repository.createTrampo(novoTrampo);

      Get.snackbar(
        'Sucesso!',
        'A vaga foi criada e já está disponível.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      debugPrint('Erro detalhado ao criar trampo: $e');
      debugPrint('Tipo do erro: ${e.runtimeType}');
      if (e is FirebaseException) {
        debugPrint('Código do erro Firebase: ${e.code}');
        debugPrint('Mensagem do erro Firebase: ${e.message}');
      }

      Get.snackbar(
        'Operação Falhou',
        'Não foi possível criar a vaga. Erro: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //=======================================================================================================================

  Future<List> listarTrampos() async {
    try {
      isLoading.value = true;
      return await _listarTramposUsecases();
    } on FirebaseException catch (e) {
      isLoading.value = false;
      return Future.error('Erro ao listar agendamentos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //=======================================================================================================================

  Future<void> carregarMinhasVagas() async {
    try {
      isLoading.value = true;
      final vagas = await _listarTramposUsecases.getMinhasVagas();
      minhasVagas.value = vagas;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar suas vagas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //=======================================================================================================================

  Future<void> deleteTrampos(String trampoId) async {
    try {
      await _repository.deleteTrampos(trampoId);
      await carregarMinhasVagas();
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
        colorText: Colors.white,
      );
    }
  }

  Future<void> alterStatusTrampo(
    String idTrampo,
    String status,
    String uuid,
  ) async {
    try {
      await _repository.updateTrampoStatus(
        idTrampo,
        status == 'Disponivel' ? 'Encerrado' : 'Disponivel',
        auth.currentUser?.uid ?? '',
      );
      await carregarMinhasVagas();
    } on FirebaseException catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }

  Future<void> toggleTheme() async {
    await themeController.toggleTheme();
  }

  //=======================================================================================================================

  Future<void> salvarVaga(Map<String, dynamic> vagaData) async {
    try {
      final jaExiste = vagasSalvas.any((vaga) => vaga['id'] == vagaData['id']);

      if (jaExiste) {
        Get.snackbar(
          'Vaga já salva',
          'Esta vaga já está nos seus favoritos',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      vagaData['dataSalvamento'] = DateTime.now().toIso8601String();
      vagasSalvas.add(vagaData);
      await _salvarVagasLocal();

      Get.snackbar(
        'Vaga Salva',
        'Vaga adicionada aos seus favoritos',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao salvar vaga: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removerVagaSalva(Map<String, dynamic> vagaData) async {
    try {
      vagasSalvas.removeWhere((vaga) => vaga['id'] == vagaData['id']);
      await _salvarVagasLocal();

      Get.snackbar(
        'Vaga Removida',
        'Vaga removida dos seus favoritos',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao remover vaga: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> carregarVagasSalvas() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      final doc =
          await firestore
              .collection('usuarios')
              .doc(userId)
              .collection('vagasSalvas')
              .get();

      vagasSalvas.value =
          doc.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint('Erro ao carregar vagas salvas: $e');
    }
  }

  Future<void> _salvarVagasLocal() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      final batch = firestore.batch();
      final collection = firestore
          .collection('usuarios')
          .doc(userId)
          .collection('vagasSalvas');

      final existingDocs = await collection.get();
      for (final doc in existingDocs.docs) {
        batch.delete(doc.reference);
      }

      for (final vaga in vagasSalvas) {
        final docRef = collection.doc(vaga['id']);
        batch.set(docRef, vaga);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Erro ao salvar vagas localmente: $e');
    }
  }
}
