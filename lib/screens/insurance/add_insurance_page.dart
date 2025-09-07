import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/insurance_model.dart';
import '../../services/db_service.dart';

class AddInsurancePage extends StatefulWidget {
  const AddInsurancePage({super.key});

  @override
  State<AddInsurancePage> createState() => _AddInsurancePageState();
}

class _AddInsurancePageState extends State<AddInsurancePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _policyNumberController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _uploadedDate;
  String? _pdfPath;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _pickUploadedDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _uploadedDate = pickedDate;
      });
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfPath = result.files.single.path!;
      });
    }
  }

  void _saveInsurance() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _uploadedDate != null) {
      final insurance =
          InsuranceModel()
            ..policyNumber = _policyNumberController.text.trim()
            ..companyName = _companyNameController.text.trim()
            ..amount = double.tryParse(_amountController.text.trim()) ?? 0.0
            ..startDate = _startDate!
            ..endDate = _endDate!
            // ..uploadedDate = _uploadedDate!
            ..uploadedDate = DateTime.now()
            ..remarks = _remarksController.text.trim()
            ..pdfPath = _pdfPath
            ..category = selectedCategory;

      await DBService().addInsurance(insurance); // ✅ Correct

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insurance added successfully!')),
      );

      Navigator.pop(context); // Or clear form fields if needed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // 1️⃣ Add this state field and category list at the top of _AddInsurancePageState
  String selectedCategory = 'Insurance';
  final List<String> categories = [
    'Insurance',
    'PAN',
    'PUCC',
    'Permit',
    'Road Tax',
    'Fitness',
    'Vehicle',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Insurance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _policyNumberController,
                decoration: const InputDecoration(labelText: "Policy Number"),
                validator:
                    (value) => value!.isEmpty ? "Enter policy number" : null,
              ),
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: "Company Name"),
                validator:
                    (value) => value!.isEmpty ? "Enter company name" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text("Start Date: ${formatDate(_startDate)}"),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDate(context, true),
                    child: const Text("Select"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("End Date: ${formatDate(_endDate)}")),
                  ElevatedButton(
                    onPressed: () => _pickDate(context, false),
                    child: const Text("Select"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text("Uploaded Date: ${formatDate(_uploadedDate)}"),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickUploadedDate(context),
                    child: const Text("Select"),
                  ),
                ],
              ),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items:
                    categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(labelText: "Remarks"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickPdf,
                child: Text(
                  _pdfPath == null
                      ? "Attach PDF (optional)"
                      : "PDF Attached: ${_pdfPath!.split(Platform.pathSeparator).last}",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInsurance,
                child: const Text("Save Insurance"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
