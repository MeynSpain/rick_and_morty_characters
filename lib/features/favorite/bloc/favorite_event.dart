part of 'favorite_bloc.dart';

@immutable
abstract class FavoriteEvent extends Equatable {}

class FavoriteGetCharactersEvent extends FavoriteEvent {
  @override
  List<Object?> get props => [];
}

class FavoriteToggleEvent extends FavoriteEvent {
  final Character character;

  FavoriteToggleEvent({required this.character});

  @override
  List<Object?> get props => [character];
}
