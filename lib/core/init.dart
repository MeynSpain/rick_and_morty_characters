import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:rick_and_morty_characters/core/repositories/settings_repository/settings_repository.dart';
import 'package:rick_and_morty_characters/core/theme/bloc/theme_cubit.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

const characterBoxName = 'charactersBox';
const settingsBoxName = 'settingsBox';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Инициализация Talker.

  final talker = TalkerFlutter.init();



  // Ставлю talker на наблюдателя для блока, потому что иначе ничего не видно
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: true,
      printStateFullData: true,
    ),
  );

  // Инициализация dio

  final Dio dio = Dio();

  // Hive и репозитории

  await Hive.initFlutter();

  Hive.registerAdapter(CharacterAdapter());

  final characterBox = await Hive.openBox<Character>(characterBoxName);

  final characterRepository = CharactersRepository(
    dio: dio,
    characterBox: characterBox,
  );

  final settingBox = await Hive.openBox(settingsBoxName);

  final settingRepository = SettingsRepository(settingsBox: settingBox);

  // Регистрация всех сущностей

  getIt.registerSingleton(talker);

  getIt.registerLazySingleton(() => characterRepository);

  getIt.registerLazySingleton(
    () => CharactersListBloc(repository: characterRepository),
  );

  getIt.registerLazySingleton(
    () => FavoriteBloc(repository: characterRepository),
  );

  getIt.registerLazySingleton(() => settingRepository);

  getIt.registerSingleton(ThemeCubit(settingsRepository: settingRepository));

  // Вызов необходимых ивентов

  getIt<Talker>().info('Application started...');

  getIt<CharactersListBloc>().add(CharactersListGetListEvent(page: 1));
}
