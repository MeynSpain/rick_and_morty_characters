import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:rick_and_morty_characters/core/model/character.dart';

class CharactersRepository {
  final Dio dio;
  final Box<Character> characterBox;

  CharactersRepository({required this.characterBox, required this.dio});

  Future<List<Character>> getCharactersPage(int page) async {
    List<Character> characters = [];

    try {
      characters = await _fetchCharactersFromApi(page);

      await _saveCharactersToHive(characters);

      final result = characterBox.values.toList();
    } catch (e, st) {
      log('$e');

      characters = characterBox.values.toList();
    }

    return characters;
  }

  List<Character> getFavoriteCharacters() {
    final favoriteCharacters =
        characterBox.values.where((character) => character.isFavorite).toList();

    return favoriteCharacters;
  }

  Future<List<Character>> _fetchCharactersFromApi(int page) async {
    final response = await dio
        .get('https://rickandmortyapi.com/api/character/?page=$page')
        .timeout(Duration(seconds: 2));

    final data = response.data as Map<String, dynamic>;

    final results = data['results'] as List<dynamic>;

    final characters = results.map((json) => Character.fromJson(json)).toList();

    return characters;
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

  Future<void> saveCharacter(Character character) async {
    await characterBox.put(character.id, character);
  }
}
