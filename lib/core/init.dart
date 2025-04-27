import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

const characterBoxName = 'charactersBox';

final GetIt getIt = GetIt.instance;

Future<void> init() async {

  final talker = TalkerFlutter.init();
  getIt.registerSingleton(talker);
  getIt<Talker>().info('Application started...');

  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: true,
        printStateFullData: true,
      ));

  final Dio dio = Dio();

  await Hive.initFlutter();
  Hive.registerAdapter(CharacterAdapter());

  final characterBox = await Hive.openBox<Character>(characterBoxName);

  final repository = CharactersRepository(dio: dio, characterBox: characterBox);

  getIt.registerLazySingleton(() => repository);

  getIt.registerLazySingleton(() => CharactersListBloc(repository: repository));

  getIt.registerLazySingleton(() => FavoriteBloc(repository: repository));


  getIt<CharactersListBloc>().add(CharactersListGetListEvent(page: 1));
}
