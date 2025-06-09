import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/bindings/login_bindings.dart';
import 'package:interprise_calendar/app/routs/app_routes.dart';
import 'package:interprise_calendar/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
      initialBinding: LoginBindings(),
    );
  }
}
