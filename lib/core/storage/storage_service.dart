import 'package:hive_flutter/hive_flutter.dart';

class ThemeStorageService {
  ThemeStorageService._();
  static final ThemeStorageService instance = ThemeStorageService._();

  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  Box get _box => Hive.box(_boxName);

  /// Save theme
  Future<void> saveThemeMode(String mode) async {
    await _box.put(_themeKey, mode);
  }

  /// Get theme
  String? getThemeMode() {
    return _box.get(_themeKey);
  }
}
