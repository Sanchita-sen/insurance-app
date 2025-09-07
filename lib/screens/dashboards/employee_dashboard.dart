import 'package:flutter/material.dart';

class EmployeeDashboardPage extends StatelessWidget {
  const EmployeeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Dashboard")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _dashboardTile(
            context,
            Icons.picture_as_pdf,
            "My Assigned Documents",
            () {},
          ),
          _dashboardTile(context, Icons.check_circle, "Mark Tasks Done", () {}),
          _dashboardTile(context, Icons.bar_chart, "My Reports", () {}),
        ],
      ),
    );
  }

  Widget _dashboardTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
