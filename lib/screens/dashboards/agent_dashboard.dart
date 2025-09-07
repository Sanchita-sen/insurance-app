import 'package:flutter/material.dart';

class AgentDashboardPage extends StatelessWidget {
  const AgentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agent Dashboard")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _dashboardTile(context, Icons.person, "My Clients", () {}),
          _dashboardTile(
            context,
            Icons.picture_as_pdf,
            "Assigned Documents",
            () {},
          ),
          _dashboardTile(context, Icons.bar_chart, "Reports", () {}),
          _dashboardTile(context, Icons.message, "Client Messages", () {}),
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
