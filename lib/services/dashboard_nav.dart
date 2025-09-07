import 'package:flutter/material.dart';
import 'package:insurance_app/screens/dashboards/admin_dashboard.dart';
import 'package:insurance_app/screens/dashboards/agent_dashboard.dart';
import 'package:insurance_app/screens/dashboards/employee_dashboard.dart';
import 'package:insurance_app/services/role.dart';

void navigateToDashboard(BuildContext context, Role role) {
  Widget page;
  switch (role) {
    case Role.admin:
      page = const AdminDashboardPage();
      break;
    case Role.agent:
      page = const AgentDashboardPage();
      break;
    case Role.employee:
      page = const EmployeeDashboardPage();
      break;
  }
  Navigator.of(
    context,
  ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => page), (_) => false);
}
