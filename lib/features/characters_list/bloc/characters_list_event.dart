part of 'characters_list_bloc.dart';

@immutable
abstract class CharactersListEvent extends Equatable {}

class CharactersListGetListEvent extends CharactersListEvent {
  final int page;

  CharactersListGetListEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class CharactersListToggleFavoriteEvent extends CharactersListEvent {
  final Character character;

  CharactersListToggleFavoriteEvent({required this.character});

  @override
  List<Object?> get props => [character];
}
