import 'package:hive_flutter/hive_flutter.dart';

class AuthStorageService {
  AuthStorageService._();
  static final AuthStorageService instance = AuthStorageService._();

  static const _boxName = "authBox";
  static const _roleKey = "userRole";

  Box get _box => Hive.box(_boxName);

  Future<void> saveRole(String role) async {
    await _box.put(_roleKey, role);
  }

  String? getRole() {
    return _box.get(_roleKey);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
