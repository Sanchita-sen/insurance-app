import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/insurance_model.dart';

class DBService {
  static final DBService _instance = DBService._internal();

  late Isar _isar;

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _isar = await Isar.open([InsuranceModelSchema], directory: dir.path);
  }

  // Add or update insurance
  Future<void> addInsurance(InsuranceModel model) async {
    await _isar.writeTxn(() async {
      await _isar.insuranceModels.put(model);
    });
  }

  // Get all insurances (latest first)
  Future<List<InsuranceModel>> getAllInsurance() async {
    return await _isar.insuranceModels
        .where()
        .sortByUploadedDateDesc()
        .findAll();
  }

  // Delete by id
  Future<void> deleteInsurance(int id) async {
    await _isar.writeTxn(() async {
      await _isar.insuranceModels.delete(id);
    });
  }

  // Get insurance by id (optional usage)
  Future<InsuranceModel?> getInsuranceById(int id) async {
    return await _isar.insuranceModels.get(id);
  }

  // Clear all data (for reset/debug)
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.insuranceModels.clear();
    });
  }
}
