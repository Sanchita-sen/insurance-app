import 'role.dart';

class SessionUser {
  final String id;
  final String name;
  final Role role;

  SessionUser({required this.id, required this.name, required this.role});
}

// Simple in-memory session holder (replace with your auth/isar as needed)
class Session {
  static SessionUser? current;

  static bool get isLoggedIn => current != null;
  static Role? get role => current?.role;

  static void signIn(SessionUser user) => current = user;
  static void signOut() => current = null;
}
