import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewPage extends StatelessWidget {
  final String filePath;
  final String title;
  final DateTime? expiryDate;

  const PdfPreviewPage({
    super.key,
    required this.filePath,
    required this.title,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    final fileExists = file.existsSync();
    final fileSize =
        fileExists ? (file.lengthSync() / 1024).toStringAsFixed(2) : "0";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          fileExists
              ? Column(
                children: [
                  Expanded(child: SfPdfViewer.file(file)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("File Name: ${file.uri.pathSegments.last}"),
                        Text("Size: $fileSize KB"),
                        if (expiryDate != null)
                          Text(
                            "Expiry: ${DateFormat('dd MMM yyyy').format(expiryDate!)}",
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Share or Download logic
                          },
                          child: const Text("Share / Download"),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(child: Text("File not found")),
    );
  }
}
