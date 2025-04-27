import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/model/info.dart';

class ApiResponse {
  final Info info;
  final List<Character> characters;

  ApiResponse({required this.info, required this.characters});

}
