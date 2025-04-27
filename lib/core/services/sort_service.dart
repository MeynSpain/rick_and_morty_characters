import 'package:rick_and_morty_characters/core/model/character.dart';

class SortService {
  static List<Character> sortById({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
      (a, b) => isAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id),
    );
  }

  static List<Character> sortByName({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
      (a, b) =>
          isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
    );
  }

  static List<Character> sortByStatus({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
          (a, b) =>
      isAscending ? a.status.compareTo(b.status) : b.status.compareTo(a.status),
    );
  }

  static List<Character> sortBySpecies({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
          (a, b) =>
      isAscending ? a.species.compareTo(b.species) : b.species.compareTo(a.species),
    );
  }

  static List<Character> sortByType({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
          (a, b) =>
      isAscending ? a.type.compareTo(b.type) : b.type.compareTo(a.type),
    );
  }

  static List<Character> sortByGender({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
          (a, b) =>
      isAscending ? a.gender.compareTo(b.gender) : b.gender.compareTo(a.gender),
    );
  }

  static List<Character> sortByOrigin({
    required List<Character> characters,
    required bool isAscending,
  }) {
    return List<Character>.from(characters)..sort(
          (a, b) =>
      isAscending ? a.origin.compareTo(b.origin) : b.origin.compareTo(a.origin),
    );
  }
}
