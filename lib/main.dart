// lib/main.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart'; // [cite: 3]
// import 'firebase_options.dart'; // Certifique-se que este arquivo existe (gerado pelo FlutterFire CLI)
// import 'presentation/routs/app_routes.dart';

// import 'app/bindings/app_bindings.dart';
// // import 'app/services/notification_service.dart'; // Se você tiver este serviço [cite: 2]
// void main() async {
// WidgetsFlutterBinding.ensureInitialized(); // [cite: 2]
// // Inicializar Firebase [cite: 3]
// await Firebase.initializeApp(
// options: DefaultFirebaseOptions.currentPlatform, // [cite: 3]
// );
// // Inicializar outros serviços se necessário, como NotificationService [cite: 2]
// // final notificationService = NotificationService();
// // await notificationService.init();
// // Get.put(notificationService, permanent: true); [cite: 2]
// // Get.put(HabitController(), permanent: true); // Exemplo do seu PDF, adapte ou remova [cite: 2]
// runApp(const AgendaProApp());
// }
// class AgendaProApp extends StatelessWidget {
// const AgendaProApp({super.key});
// @override
// Widget build(BuildContext context) {
// return GetMaterialApp(
// title: 'AgendaPro App', // Ajustado do MVC App [cite: 2]
// debugShowCheckedModeBanner: false,
// theme: ThemeData(
// primarySwatch: Colors.teal, // [cite: 2]
// visualDensity: VisualDensity.adaptivePlatformDensity, // [cite: 2]
// colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary:
// Colors.amber),
// ),
// initialRoute: AppRoutes.initialRoute, // [cite: 2]
// getPages: AppRoutes.routes,
// initialBinding: AppBindings(), // [cite: 2]
// unknownRoute: AppRoutes.unknownRoute, // [cite: 2]
// );
// }
// }
