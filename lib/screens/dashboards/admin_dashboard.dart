import 'package:flutter/material.dart';
import 'package:insurance_app/screens/insurance/view_insurance_page.dart';
import 'package:insurance_app/services/dashboard_tile.dart';
// import '../../insurance/view_insurance_page.dart'; // <- your existing page

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: GridView.count(
        padding: const EdgeInsets.all(12),
        crossAxisCount: 2,
        children: [
          DashboardTile(
            icon: Icons.people,
            title: "User Management",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _UserManagementStub()),
              );
            },
          ),
          DashboardTile(
            icon: Icons.picture_as_pdf,
            title: "Insurance Records",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ViewInsurancePage()),
              );
            },
          ),
          DashboardTile(
            icon: Icons.folder_open,
            title: "All Documents",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _AllDocumentsStub()),
              );
            },
          ),
          DashboardTile(
            icon: Icons.cloud_upload,
            title: "Backup & Restore",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _BackupRestoreStub()),
              );
            },
          ),
          DashboardTile(
            icon: Icons.bar_chart,
            title: "Reports",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _ReportsStub()),
              );
            },
          ),
          DashboardTile(
            icon: Icons.settings,
            title: "Settings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _SettingsStub()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Simple stubs (replace with your real pages) ---
class _UserManagementStub extends StatelessWidget {
  const _UserManagementStub();
  @override
  Widget build(BuildContext context) => const _Stub(title: "User Management");
}

class _AllDocumentsStub extends StatelessWidget {
  const _AllDocumentsStub();
  @override
  Widget build(BuildContext context) => const _Stub(title: "All Documents");
}

class _BackupRestoreStub extends StatelessWidget {
  const _BackupRestoreStub();
  @override
  Widget build(BuildContext context) => const _Stub(title: "Backup & Restore");
}

class _ReportsStub extends StatelessWidget {
  const _ReportsStub();
  @override
  Widget build(BuildContext context) => const _Stub(title: "Reports");
}

class _SettingsStub extends StatelessWidget {
  const _SettingsStub();
  @override
  Widget build(BuildContext context) => const _Stub(title: "Settings");
}

class _Stub extends StatelessWidget {
  final String title;
  const _Stub({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title page (TODO)")),
    );
  }
}
