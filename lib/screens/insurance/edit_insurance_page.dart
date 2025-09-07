import 'package:flutter/material.dart';
// import 'package:insurance_app/app_init.dart';
import 'package:insurance_app/models/insurance_model.dart';
import 'package:insurance_app/services/isar_service.dart';

// import '../../services/insurance_service.dart';
class EditInsurancePage extends StatefulWidget {
  final InsuranceModel insurance;

  const EditInsurancePage({super.key, required this.insurance});

  @override
  State<EditInsurancePage> createState() => _EditInsurancePageState();
}

class _EditInsurancePageState extends State<EditInsurancePage> {
  late TextEditingController policyController;
  late TextEditingController companyController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    policyController = TextEditingController(
      text: widget.insurance.policyNumber,
    );
    companyController = TextEditingController(
      text: widget.insurance.companyName,
    );
    // categoryController = TextEditingController(text: widget.insurance.category);
  }

  Future<void> saveChanges() async {
    final isar = IsarService().isar;
    widget.insurance.policyNumber = policyController.text.trim();
    widget.insurance.companyName = companyController.text.trim();
    // widget.insurance.category = categoryController.text.trim();

    await isar.writeTxn(() async {
      await isar.insuranceModels.put(widget.insurance);
    });

    Navigator.pop(context); // Go back to list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Insurance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: policyController,
              decoration: const InputDecoration(labelText: "Policy Number"),
            ),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: "Company"),
            ),
            // TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Category")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveChanges, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
