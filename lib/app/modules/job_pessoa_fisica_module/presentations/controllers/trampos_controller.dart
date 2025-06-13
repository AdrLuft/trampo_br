import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trampos_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trasmpos_delete_usecase.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class TramposController extends GetxController {
  final ListarTramposPessoaFisicaUsecases _listarTramposUsecases;
  late final DeleteTramposUsecase _deleteTramposUsecase;
  final isLoading = false.obs;
  final TramposRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GlobalThemeController get themeController =>
      Get.find<GlobalThemeController>();

  TramposController(this._listarTramposUsecases, this._repository);
  //=======================================================================================================================

  Future<void> createTrampo({
    required String descricao,
    required String tipoVaga,
    required String telefone,
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

  Future<void> deleteTrampo(String id) async {
    try {
      isLoading.value = true;
      await _deleteTramposUsecase.call(id);
    } on FirebaseException catch (e) {
      isLoading.value = false;
      return Future.error('Erro ao deletar agendamento: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final minhasVagas = <TramposEntiti>[].obs;

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

  Future<void> excluirMeuTrampo(String id) async {
    try {
      await deleteTrampo(id);
      await carregarMinhasVagas();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao excluir vaga: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> toggleTheme() async {
    await themeController.toggleTheme();
  }
}
