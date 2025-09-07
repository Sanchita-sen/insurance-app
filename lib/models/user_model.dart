import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class UserModel {
  Id id = Isar.autoIncrement;

  late String username;
  late String passwordHash;
  late String role; // 'admin', 'agent', 'employee'
}
