// import 'app/services/notification_service.dart'; // Se você tiver este serviço [cite: 2]
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:interprise_calendar/app/modules/job_module/bindings/job_bindings.dart';
import 'package:interprise_calendar/app/routs/app_routes.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // [cite: 2]
  // // Inicializar Firebase [cite: 3]
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform, // [cite: 3]
  // );
  // // Inicializar outros serviços se necessário, como NotificationService [cite: 2]
  // final notificationService = NotificationService();
  // await notificationService.init();
  // Get.put(notificationService, permanent: true); [cite: 2]
  // Get.put(HabitController(), permanent: true); // Exemplo do seu PDF, adapte ou remova [cite: 2]
  runApp(const TrampoBR());
}

class TrampoBR extends StatelessWidget {
  const TrampoBR({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Trampo BR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(secondary: Colors.amber),
      ),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.routes,
      initialBinding: AppBindings(),
    );
  }
}
