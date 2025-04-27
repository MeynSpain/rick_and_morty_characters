part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<Character> favoriteCharacters;
  final String errorMessage;

  final String currentOption;
  final bool isAscending;

  const FavoriteState._({
    required this.favoriteCharacters,
    required this.status,
    required this.errorMessage,
    required this.currentOption,
    required this.isAscending,
  });

  factory FavoriteState.initial() {
    return const FavoriteState._(
      favoriteCharacters: [],
      status: FavoriteStatus.initial,
      errorMessage: '',
      currentOption: 'Id',
      isAscending: true,
    );
  }

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<Character>? favoriteCharacters,
    String? errorMessage,
    String? currentOption,
    bool? isAscending,
  }) {
    return FavoriteState._(
      favoriteCharacters: favoriteCharacters ?? this.favoriteCharacters,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentOption: currentOption ?? this.currentOption,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favoriteCharacters,
    errorMessage,
    currentOption,
    isAscending,
  ];
}
