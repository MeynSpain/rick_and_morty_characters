part of 'characters_list_bloc.dart';

class CharactersListState extends Equatable {
  final CharactersListStatus status;
  final List<Character> characters;
  final String errorMessage;
  final int currentPage;
  final int totalPage;

  const CharactersListState._({
    required this.characters,
    required this.status,
    required this.errorMessage,
    required this.currentPage,
    required this.totalPage,
  });

  factory CharactersListState.initial() {
    return const CharactersListState._(
      characters: [],
      status: CharactersListStatus.initial,
      errorMessage: '',
      currentPage: 1,
      totalPage: 42,
    );
  }

  CharactersListState copyWith({
    CharactersListStatus? status,
    List<Character>? characters,
    String? errorMessage,
    int? currentPage,
    int? totalPage,
  }) {
    return CharactersListState._(
      characters: characters ?? this.characters,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    characters,
    errorMessage,
    currentPage,
    totalPage,
  ];
}
