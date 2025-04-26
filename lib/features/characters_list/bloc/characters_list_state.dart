part of 'characters_list_bloc.dart';

class CharactersListState extends Equatable {

  final CharactersListStatus status;
  final List<Character> characters;
  final String errorMessage;

  const CharactersListState._({
    required this.characters,
    required this.status,
    required this.errorMessage,
  });

  factory CharactersListState.initial() {
    return const CharactersListState._(
      characters: [],
      status: CharactersListStatus.initial,
      errorMessage: '',
    );
  }

  CharactersListState copyWith({
    CharactersListStatus? status,
    List<Character>? characters,
    String? errorMessage
  }) {
    return CharactersListState._(
      characters: characters ?? this.characters,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }


  @override
  List<Object?> get props => [
    status,
    characters,
    errorMessage,
  ];

}

