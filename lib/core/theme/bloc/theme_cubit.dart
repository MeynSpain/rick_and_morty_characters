import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/repositories/settings_repository/settings_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SettingsRepository _settingsRepository;

  ThemeCubit({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository,
      super(ThemeState(brightness: Brightness.light)) {
    _getCachedBrightness();
  }

  Future<void> setThemeBrightness(Brightness brightness) async {
    emit(ThemeState(brightness: brightness));
    await _settingsRepository.setDarkThemeSelected(
      brightness == Brightness.dark,
    );
    getIt<Talker>().info('Save brightness = $brightness');
  }

  void _getCachedBrightness() {
    try {
      final brightness =
          _settingsRepository.getDarkThemeSelected()
              ? Brightness.dark
              : Brightness.light;
      emit(ThemeState(brightness: brightness));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(ThemeState(brightness: Brightness.light));
    }
  }
}
