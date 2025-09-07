import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../models/insurance_model.dart';
import '../../services/insurance_service.dart';
import 'edit_insurance_page.dart';
import 'pdf_viewer_page.dart';

class ViewInsurancePage extends StatefulWidget {
  const ViewInsurancePage({super.key});

  @override
  State<ViewInsurancePage> createState() => _ViewInsurancePageState();
}

class _ViewInsurancePageState extends State<ViewInsurancePage> {
  final InsuranceService _service = InsuranceService();
  final TextEditingController _searchController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  List<InsuranceModel> _insuranceList = [];
  List<InsuranceModel> _filteredInsuranceList = [];

  String selectedCategoryFilter = 'All';
  List<String> categoryFilters = [
    'All',
    'Insurance',
    'PAN',
    'PUCC',
    'Permit',
    'Road Tax',
    'Fitness',
    'Vehicle',
  ];

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await _service.getAllInsurance();
    setState(() {
      _insuranceList = data;
      _filteredInsuranceList = data;
    });
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredInsuranceList =
          _insuranceList.where((item) {
            final matchesSearch =
                item.companyName.toLowerCase().contains(query) ||
                item.policyNumber.toLowerCase().contains(query);
            final matchesCategory =
                selectedCategoryFilter == 'All' ||
                item.category == selectedCategoryFilter;
            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  Future<void> _deleteItem(int id) async {
    await _service.deleteInsurance(id);
    _loadData();
  }

  /// Biometric or PIN prompt
  Future<bool> _authenticateUser() async {
    try {
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to share the document',
        options: const AuthenticationOptions(biometricOnly: false),
      );
      return didAuthenticate;
    } catch (e) {
      debugPrint('Auth error: $e');
      return false;
    }
  }

  /// Share via email
  Future<void> _shareViaEmail(String companyName, String pdfPath) async {
    final file = File(pdfPath);
    if (!await file.exists()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PDF file not found")));
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      query: Uri.encodeFull(
        'subject=Insurance Document: $companyName&body=Attached is your insurance document.',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open email app")));
    }
  }

  /// Share via WhatsApp / others
  Future<void> _shareViaApps(
    String companyName,
    String policyNumber,
    String pdfPath,
  ) async {
    final file = File(pdfPath);
    if (!await file.exists()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PDF file not found")));
      return;
    }

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Insurance PDF: $companyName - $policyNumber');
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by company, policy, or category',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Insurance Records")),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                itemCount: _filteredInsuranceList.length,
                itemBuilder: (context, index) {
                  final item = _filteredInsuranceList[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("${item.policyNumber} - ${item.companyName}"),
                      subtitle: Text(
                        "₹${item.amount.toStringAsFixed(2)} | ${formatDate(item.startDate)} → ${formatDate(item.endDate)}\n${item.remarks ?? ''}",
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditInsurancePage(insurance: item),
                          ),
                        ).then((_) => _loadData());
                      },
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (item.pdfPath != null) ...[
                            // IconButton(
                            //   icon: const Icon(Icons.picture_as_pdf),
                            //   tooltip: 'View PDF',
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (_) =>
                            //             PDFViewerPage(filePath: item.pdfPath!),
                            //       ),
                            //     );
                            //   },
                            // ),
                            IconButton(
                              icon: const Icon(Icons.picture_as_pdf),
                              tooltip: 'View PDF',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => PdfPreviewPage(
                                          filePath: item.pdfPath!,
                                          title: item.companyName,
                                          expiryDate: item.endDate, // optional
                                        ),
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(Icons.share),
                              tooltip: 'Share via Apps',
                              onPressed: () async {
                                if (await _authenticateUser()) {
                                  await _shareViaApps(
                                    item.companyName,
                                    item.policyNumber,
                                    item.pdfPath!,
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.email),
                              tooltip: 'Share via Email',
                              onPressed: () async {
                                if (await _authenticateUser()) {
                                  await _shareViaEmail(
                                    item.companyName,
                                    item.pdfPath!,
                                  );
                                }
                              },
                            ),
                          ],
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete Record',
                            onPressed: () => _deleteItem(item.id),
                          ),
                          DropdownButton<String>(
                            value: selectedCategoryFilter,
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryFilter = value!;
                                _filterList();
                              });
                            },
                            items:
                                categoryFilters.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
