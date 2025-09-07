// login_page.dart
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:insurance_app/app_init.dart';
import 'dart:convert';

import 'package:isar/isar.dart';
// import '../services/isar_service.dart';
import '../models/user_model.dart';

// Dashboards
import 'dashboards/admin_dashboard.dart';
import 'dashboards/agent_dashboard.dart';
import 'dashboards/employee_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = '';

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> loginUser() async {
    final username = usernameController.text.trim();
    final password = hashPassword(passwordController.text.trim());

    final user =
        await isar.userModels
            .filter()
            .usernameEqualTo(username)
            .passwordHashEqualTo(password)
            .findFirst();

    if (user == null) {
      setState(() {
        errorText = "Invalid credentials";
      });
    } else {
      if (user.role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else if (user.role == "agent") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AgentDashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeDashboardPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insurance Manager - Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: loginUser, child: const Text("Login")),
            if (errorText.isNotEmpty)
              Text(errorText, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
