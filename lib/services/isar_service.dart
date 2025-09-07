// Future<List<InsuranceModel>> getAllInsurance() async {
//   return await isar.insuranceModels.where().findAll();
// }

// Future<void> deleteInsurance(int id) async {
//   await isar.writeTxn(() async {
//     await isar.insuranceModels.delete(id);
//   });
// }

// lib/services/isar_service.dart
import 'package:isar/isar.dart';
import '../models/insurance_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  get isar => null;

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [InsuranceModelSchema],
        inspector: true,
        directory: '',
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveInsurance(InsuranceModel insurance) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.insuranceModels.putSync(insurance));
  }

  Future<List<InsuranceModel>> getAllInsurance() async {
    final isar = await db;
    return await isar.insuranceModels.where().findAll();
  }
}
