import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/data/repository/login_repository.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(() => LoginRepository());
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginRepository>()),
    );
  }
}
