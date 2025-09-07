import 'package:flutter/material.dart';
import 'package:insurance_app/services/auto_delete_service.dart';
import 'app_init.dart'; // ✅ Import this
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeIsar(); // ✅ Initialize DB
  await createAdminIfNotExist(); // ✅ Create admin user
  await AutoDeleteService().cleanOldFiles();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Manager',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
