import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class EdicaoTrampoController extends GetxController {
  late final TramposRepositoryAbstract _repository;

  GlobalThemeController get themeController =>
      Get.find<GlobalThemeController>();

  Future<void> updateTrampos(TramposEntiti trampo) async {
    try {
      final model = CreateTramposModel.fromEntity(trampo);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Ocorreu um erro ao atualizar o trampo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
}
