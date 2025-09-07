import 'dart:io';
import 'package:insurance_app/app_init.dart';
import 'package:isar/isar.dart';
import '../models/insurance_model.dart';

class AutoDeleteService {
  Future<void> cleanOldFiles() async {
    final now = DateTime.now();
    final threshold = now.subtract(const Duration(days: 90));

    final oldRecords =
        await isar.insuranceModels
            .filter()
            .uploadedDateLessThan(threshold)
            .findAll();

    for (final record in oldRecords) {
      if (record.pdfPath != null) {
        final file = File(record.pdfPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Clear the pdfPath from the record
      record.pdfPath = null;
      await isar.writeTxn(() => isar.insuranceModels.put(record));
    }
  }
}
