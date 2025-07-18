import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/mesages_custom.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/users_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/user_repository_abstract.dart';

class ProfileController extends GetxController {
  final UserRepositoryAbstract _userRepository;

  ProfileController(this._userRepository);

  // Estados reativos para a UI observar
  final RxBool isLoading = true.obs;
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
}
