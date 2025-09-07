import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:insurance_app/models/insurance_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/user_model.dart';

late Isar isar;

Future<void> initializeIsar() async {
  if (Isar.instanceNames.isNotEmpty) {
    // Already initialized
    isar = Isar.getInstance()!;
    return;
  }

  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    UserModelSchema,
    InsuranceModelSchema,
  ], directory: dir.path);
}

Future<void> createAdminIfNotExist() async {
  final existing =
      await isar.userModels.filter().usernameEqualTo('admin').findFirst();

  if (existing == null) {
    final defaultAdmin =
        UserModel()
          ..username = 'admin'
          ..passwordHash = sha256.convert(utf8.encode('admin123')).toString()
          ..role = 'admin';

    await isar.writeTxn(() async {
      await isar.userModels.put(defaultAdmin);
    });

    print("✅ Default admin user created: admin / admin123");
  } else {
    print("✅ Admin user already exists");
  }
}
