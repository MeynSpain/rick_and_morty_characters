import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_characters/core/const/status/favorite_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:rick_and_morty_characters/core/services/sort_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final CharactersRepository repository;

  FavoriteBloc({required this.repository}) : super(FavoriteState.initial()) {
    on<FavoriteGetCharactersEvent>(_getCharacters);
    on<FavoriteToggleEvent>(_toggleEvent);
    on<FavoriteSortEvent>(_sort);
  }

  FutureOr<void> _getCharacters(
    FavoriteGetCharactersEvent event,
    Emitter<FavoriteState> emit,
  ) {
    emit(state.copyWith(status: FavoriteStatus.loading));

    try {
      final favoriteCharacters = repository.getFavoriteCharacters();

      emit(
        state.copyWith(
          status: FavoriteStatus.success,
          favoriteCharacters: favoriteCharacters,
          errorMessage: '',
        ),
      );
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(
        state.copyWith(
          status: FavoriteStatus.error,
          errorMessage: e.toString(),
        ),
      );
    } finally {
      event.completer?.complete();
    }
  }

  FutureOr<void> _toggleEvent(
    FavoriteToggleEvent event,
    Emitter<FavoriteState> emit,
  ) {
    try {
      final characters = List<Character>.from(state.favoriteCharacters);

      characters.remove(event.character);

      emit(
        state.copyWith(
          status: FavoriteStatus.success,
          favoriteCharacters: characters,
        ),
      );
    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(
        state.copyWith(
          status: FavoriteStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _sort(FavoriteSortEvent event, Emitter<FavoriteState> emit) {
    try {
      List<Character> characters = List.from(state.favoriteCharacters);

      switch (event.sortOption) {
        case 'Id':
          characters = SortService.sortById(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Name':
          characters = SortService.sortByName(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Status':
          characters = SortService.sortByStatus(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Species':
          characters = SortService.sortBySpecies(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Type':
          characters = SortService.sortByType(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Gender':
          characters = SortService.sortByGender(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
        case 'Origin':
          characters = SortService.sortByOrigin(
            characters: characters,
            isAscending: event.isAscending,
          );
          break;
      }

      emit(
        state.copyWith(
          status: FavoriteStatus.success,
          favoriteCharacters: characters,
          isAscending: event.isAscending,
          currentOption: event.sortOption,
        ),
      );

    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(
        state.copyWith(
          status: FavoriteStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
