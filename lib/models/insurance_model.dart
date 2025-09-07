import 'package:isar/isar.dart';

part 'insurance_model.g.dart';

@Collection()
class InsuranceModel {
  Id id = Isar.autoIncrement;

  late String policyNumber;
  late String companyName;
  late double amount;
  late DateTime startDate;
  late DateTime endDate;
  late DateTime uploadedDate;

  late String category;

  String? remarks;

  String? pdfPath;
}
