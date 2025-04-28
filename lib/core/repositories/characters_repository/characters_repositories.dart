import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/api_response.dart';

import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/model/info.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CharactersRepository {
  final Dio dio;
  final Box<Character> characterBox;

  CharactersRepository({required this.characterBox, required this.dio});

  Future<ApiResponse> getCharactersPage(int page) async {
    ApiResponse apiResponse;

    try {
      // Если нет проблем с сетью
      apiResponse = await _fetchCharactersFromApi(page);

      await _saveCharactersToHive(apiResponse.characters);
    } catch (e, st) {
      // Если проблемы с сетью
      getIt<Talker>().handle(e, st);

      apiResponse = _fetchCharactersFromHive(page);
    }

    return apiResponse;
  }

  List<Character> getFavoriteCharacters() {
    final favoriteCharacters =
        characterBox.values.where((character) => character.isFavorite).toList();

    return favoriteCharacters;
  }

  Future<ApiResponse> _fetchCharactersFromApi(int page) async {
    final response = await dio
        .get('https://rickandmortyapi.com/api/character/?page=$page')
        .timeout(Duration(seconds: 3));

    final data = response.data as Map<String, dynamic>;

    final jsonInfo = data['info'] as Map<String, dynamic>;

    final info = Info.fromJson(jsonInfo);

    final results = data['results'] as List<dynamic>;

    final characters = results.map((json) => Character.fromJson(json)).toList();

    return ApiResponse(info: info, characters: characters);
  }

  Future<void> _saveCharactersToHive(List<Character> characters) async {
    /* Этот для putAll
    final characterMap = {
      for (var character in characters) character.id: character,
    };

    await characterBox.putAll(characterMap);
     */

    // С сохранением флага isFavorite
    // Мне конечно не очень нравится такой способ, но лучше пока не придумал
    for (var character in characters) {
      final cachedCharacter = characterBox.get(character.id);

      if (cachedCharacter != null) {
        character.isFavorite = cachedCharacter.isFavorite;
      }
      await characterBox.put(character.id, character);
    }
  }

  ApiResponse _fetchCharactersFromHive(int page) {
    const int pageSize = 20;

    final countCharacters = characterBox.values.length;

    int pages = countCharacters ~/ pageSize + 1;

    final characters =
        characterBox
            .valuesBetween(
              startKey: (page - 1) * pageSize + 1,
              endKey: page * pageSize,
            )
            .toList();

    final apiResponse = ApiResponse(
      info: Info(currentPage: page, totalPage: pages),
      characters: characters,
    );

    return apiResponse;
  }

  Future<void> saveCharacter(Character character) async {
    await characterBox.put(character.id, character);
  }

  Future<ApiResponse> getCharacterByName(String name, {int page = 1}) async {
    ApiResponse apiResponse;

    try {
      // Если нет проблем с сетью
      apiResponse = await _fetchCharactersByNameFromApi(name, page);

      await _saveCharactersToHive(apiResponse.characters);
    } catch (e, st) {
      // Если проблемы с сетью
      getIt<Talker>().handle(e, st);

      apiResponse = _fetchCharactersByNameFromHive(name, page);
    }

    return apiResponse;
  }

  Future<ApiResponse> _fetchCharactersByNameFromApi(
    String name,
    int page,
  ) async {
    final response = await dio
        .get('https://rickandmortyapi.com/api/character/?page=$page&name=$name')
        .timeout(Duration(seconds: 3));

    final data = response.data as Map<String, dynamic>;

    final jsonInfo = data['info'] as Map<String, dynamic>;

    final info = Info.fromJson(jsonInfo);

    final results = data['results'] as List<dynamic>;

    final characters = results.map((json) => Character.fromJson(json)).toList();

    return ApiResponse(info: info, characters: characters);
  }

  ApiResponse _fetchCharactersByNameFromHive(String name, int page) {
    const int pageSize = 20;

    final charactersByName = characterBox.values.where(
      (character) => character.name.toLowerCase().contains(name.toLowerCase()),
    ).toList();

    final countCharacters = charactersByName.length;
    print('Что нашел');
    print(charactersByName);

    int pages = countCharacters ~/ pageSize + 1;

    final pageCharactersByName = charactersByName.sublist(
      (page - 1) * pageSize,
      page < pages ? page * pageSize : null,
    );

    final apiResponse = ApiResponse(
      info: Info(currentPage: page, totalPage: pages),
      characters: pageCharactersByName,
    );

    return apiResponse;
  }
}
