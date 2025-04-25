import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:rick_and_morty_characters/features/charactes_list/bloc/characters_list_bloc.dart';

final GetIt getIt = GetIt.instance;

void init() {
  final Dio dio = Dio();

  final repository = CharactersRepository(dio: dio);

  getIt.registerLazySingleton(() => repository);

  getIt.registerLazySingleton(() => CharactersListBloc(repository: repository));
}
