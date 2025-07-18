import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/data/repository/login_repository.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    Get.lazyPut<LoginRepository>(() => LoginRepository());
    Get.lazyPut<LoginController>(() => LoginController(Get.find()));
  }
}
