import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trampos_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
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

  Future<void> createTrampo({
    required String descricao,
    required String tipoVaga,
    required String telefone,
    required List<String> requisitos,
    required List<String> exigencias,
    required List<String> valorizados,
    required List<String> beneficios,
    String titulo = '',
    String modalidade = 'Presencial',
    String salario = '',
    bool salarioACombinar = false,
  }) async {
    isLoading.value = true;

    try {
      final novoTrampo = TramposEntiti(
        id: '',
        titulo: titulo,
        descricao: descricao,
        telefone: telefone,
        salario: salario,
        salarioACombinar: salarioACombinar,
        tipoVaga: tipoVaga,
        modalidade: modalidade,
        status: 'Disponivel',
        createDate: DateTime.now().toIso8601String(),
        email: auth.currentUser?.email ?? '',
        userId: auth.currentUser?.uid,
        createTrampoNome: '',
        userAddress: '',
        requisitos: requisitos.toList(),
        exigencias: exigencias.toList(),
        valorizados: valorizados.toList(),
        beneficios: beneficios.toList(),
      );
      // 2. Chama o repositório com a entidade pronta.
      await _repository.createTrampo(novoTrampo);
    } catch (e) {
      Get.snackbar('Erro ao Criar Vaga', e.toString());
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

  Future<void> salvarVaga(TramposEntiti trampo) async {
    final userId = auth.currentUser?.uid;

    try {
      final jaExiste = vagasSalvas.any((vaga) => vaga['id'] == trampo.id);

      if (jaExiste) {
        Get.snackbar('Atenção', 'Esta vaga já está na sua lista.');
        return;
      }

      final model = CreateTramposModel.fromEntity(trampo);
      final vagaData = model.toJson();

      vagaData['dataSalvamento'] = Timestamp.now();
      vagaData['id'] = trampo.id;
      vagasSalvas.add(vagaData);
      await _repository.sincronizarVagasSalvasComFirestore(userId!);

      Get.snackbar('Sucesso', 'Vaga salva nos seus favoritos.');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível salvar a vaga: $e');
    }
  }

  Future<void> removerVagaSalva(TramposEntiti trampo) async {
    final userId = auth.currentUser?.uid;
    try {
      vagasSalvas.removeWhere((vaga) => vaga['id'] == trampo.id);

      await _repository.sincronizarVagasSalvasComFirestore(userId!);

      Get.snackbar('Vaga Removida', 'A vaga foi removida dos seus favoritos.');
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível remover a vaga: $e');
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
}
