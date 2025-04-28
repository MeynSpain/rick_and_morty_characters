part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent extends Equatable {}

class FavoriteGetCharactersEvent extends FavoriteEvent {
  final Completer? completer;

  FavoriteGetCharactersEvent({this.completer});

  @override
  List<Object?> get props => [completer];
}

class FavoriteToggleEvent extends FavoriteEvent {
  final Character character;

  FavoriteToggleEvent({required this.character});

  @override
  List<Object?> get props => [character];
}

class FavoriteSortEvent extends FavoriteEvent {
  final String sortOption;
  final bool isAscending;

  FavoriteSortEvent({required this.sortOption, required this.isAscending});

  @override
  List<Object?> get props => [sortOption, isAscending];
}

class FavoriteSearchEvent extends FavoriteEvent {
  final String name;

  FavoriteSearchEvent({required this.name});

  @override
  List<Object?> get props => [name];
}
