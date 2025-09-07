import 'package:flutter/material.dart';
import 'role.dart';
import 'session.dart';

class RoleGuard extends StatelessWidget {
  final List<Role> allow;
  final Widget child;

  const RoleGuard({super.key, required this.allow, required this.child});

  @override
  Widget build(BuildContext context) {
    final r = Session.role;
    if (r == null || !allow.contains(r)) {
      return const Scaffold(body: Center(child: Text("Access denied")));
    }
    return child;
  }
}
