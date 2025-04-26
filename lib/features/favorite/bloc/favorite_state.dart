part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<Character> favoriteCharacters;
  final String errorMessage;

  const FavoriteState._({
    required this.favoriteCharacters,
    required this.status,
    required this.errorMessage,
  });

  factory FavoriteState.initial() {
    return const FavoriteState._(
      favoriteCharacters: [],
      status: FavoriteStatus.initial,
      errorMessage: '',
    );
  }

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<Character>? favoriteCharacters,
    String? errorMessage,
  }) {
    return FavoriteState._(
      favoriteCharacters: favoriteCharacters ?? this.favoriteCharacters,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favoriteCharacters, errorMessage];
}
