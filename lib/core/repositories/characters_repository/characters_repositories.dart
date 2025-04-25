import 'package:dio/dio.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';

class CharactersRepository {
  Future<List<Character>> getCharactersPage(int page) async {
    Dio dio = Dio();
    final response = await dio.get('https://rickandmortyapi.com/api/character/?page=$page');

    final data = response.data as Map<String, dynamic>;

    final results = data['results'] as List<dynamic>;

    final characters = results.map((json) => Character.fromJson(json)).toList();


    return characters;
  }
}