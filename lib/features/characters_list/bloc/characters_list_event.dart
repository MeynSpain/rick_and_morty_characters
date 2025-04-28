part of 'characters_list_bloc.dart';

@immutable
abstract class CharactersListEvent extends Equatable {}

class CharactersListGetListEvent extends CharactersListEvent {
  final int page;
  final Completer? completer;

  CharactersListGetListEvent({required this.page, this.completer});

  @override
  List<Object?> get props => [page, completer];
}

class CharactersListToggleFavoriteEvent extends CharactersListEvent {
  final Character character;

  CharactersListToggleFavoriteEvent({required this.character});

  @override
  List<Object?> get props => [character];
}

class CharactersListSearchEvent extends CharactersListEvent {
  final String name;
  final int page;

  CharactersListSearchEvent({required this.name, required this.page});

  @override
  List<Object?> get props => [name, page];
}
