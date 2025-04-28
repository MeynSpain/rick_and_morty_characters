import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  final Box _settingsBox;

  static const _isDarkThemeSelected = 'darkThemeSelected';

  SettingsRepository({required Box settingsBox}) : _settingsBox = settingsBox;

  Future<void> setDarkThemeSelected(bool isSelected) async {
    await _settingsBox.put(_isDarkThemeSelected, isSelected);
  }

  bool getDarkThemeSelected() {
    bool selected = _settingsBox.get(_isDarkThemeSelected);
    return selected ?? false;
  }
}