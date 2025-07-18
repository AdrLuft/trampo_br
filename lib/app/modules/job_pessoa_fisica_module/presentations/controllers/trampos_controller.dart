import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/mesages_custom.dart';
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

  TramposController(
    this._listarTramposUsecases,
    this._repository,
    //Function({String? tag}) param2,
  );

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

  Future<void> deleteTrampos(String trampoId) async {
    try {
      await _repository.deleteTrampos(trampoId);
      await carregarMinhasVagas();
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao excluir a vaga: $e');
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

  Future<void> salvarVagaFavoritos(TramposEntiti trampo) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await carregarMinhasVagas();

      final jaExiste = vagasSalvas.any((vaga) {
        final vagaId = vaga['id']?.toString() ?? '';
        final trampoId = trampo.id.toString();
        return vagaId == trampoId && vagaId.isNotEmpty;
      });
      if (jaExiste) {
        MessageUtils.showDialogMessage(
          'Aviso',
          'Você já salvou essa vaga.',
          isWarning: true,
        );
        return;
      }
      await _repository.salvarVagaFavoritos(userId, trampo.id);
      await carregarVagasSalvas();

      MessageUtils.showSucessSnackbar('Sucesso', 'Vaga Salva!');
    } catch (e) {
      MessageUtils.handleError(e, 'Não foi possível salvar a vaga: $e');
    }
  }

  Future<void> removerVagaSalva(TramposEntiti trampo) async {
    final userId = auth.currentUser?.uid;
    try {
      // Remove do Firebase
      await _repository.removerVagaSalva(userId!, trampo.id);

      // Recarrega a lista de vagas salvas do Firebase
      await carregarVagasSalvas();

      MessageUtils.showSucessSnackbar('Sucesso', 'Vaga removida com sucesso!');
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao remover a vaga salva: $e');
    }
  }

  Future<void> carregarVagasSalvas() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) return;

      // Busca os IDs das vagas salvas na coleção TramposSalvosUsers
      final vagasSalvasQuery =
          await firestore
              .collection('TramposSalvosUsers')
              .where('userId', isEqualTo: userId)
              .get();

      List<Map<String, dynamic>> vagasCarregadas = [];

      // Para cada vaga salva, busca os dados completos na coleção Trampos
      for (var doc in vagasSalvasQuery.docs) {
        final idTrampo = doc.data()['idTrampo'] as String;

        final trampoDoc =
            await firestore.collection('Trampos').doc(idTrampo).get();

        if (trampoDoc.exists) {
          final trampoData = trampoDoc.data() as Map<String, dynamic>;
          trampoData['id'] = trampoDoc.id;
          vagasCarregadas.add(trampoData);
        }
      }

      vagasSalvas.value = vagasCarregadas;
    } catch (e) {
      MessageUtils.handleError(e, 'Erro ao carregar vagas salvas: $e');
    }
  }
}
