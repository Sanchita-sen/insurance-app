import 'package:insurance_app/app_init.dart';
import 'package:isar/isar.dart';
import '../models/insurance_model.dart';
// import 'isar_service.dart';

class InsuranceService {
  Future<void> addInsurance(InsuranceModel insurance) async {
    await isar.writeTxn(() async {
      await isar.insuranceModels.put(insurance);
    });
  }

  Future<List<InsuranceModel>> getAllInsurance() async {
    return await isar.insuranceModels.where().findAll();
  }

  Future<void> deleteInsurance(int id) async {
    await isar.writeTxn(() async {
      await isar.insuranceModels.delete(id);
    });
  }

  Future<void> updateInsurance(InsuranceModel insurance) async {
    await isar.writeTxn(() async {
      await isar.insuranceModels.put(insurance);
    });
  }

  /// Get insurance by ID
  Future<InsuranceModel?> getInsuranceById(int id) async {
    return await isar.insuranceModels.get(id);
  }
}
