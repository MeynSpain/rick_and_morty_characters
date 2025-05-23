import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_characters/core/const/status/characters_list_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'characters_list_event.dart';

part 'characters_list_state.dart';

class CharactersListBloc
    extends Bloc<CharactersListEvent, CharactersListState> {
  final CharactersRepository repository;

  CharactersListBloc({required this.repository})
    : super(CharactersListState.initial()) {
    on<CharactersListGetListEvent>(_getList);
    on<CharactersListToggleFavoriteEvent>(_addFavorite);
    on<CharactersListSearchEvent>(_search);
  }

  Future<void> _getList(
    CharactersListGetListEvent event,
    Emitter<CharactersListState> emit,
  ) async {
    if (state.status == CharactersListStatus.loading) return;

    if (event.page > state.totalPage) return;

    try {
      emit(state.copyWith(status: CharactersListStatus.loading));

      getIt<Talker>().info('Загрузка данных...');

      List<Character> characters = [];

      final apiResponse = await repository.getCharactersPage(event.page);

      characters =
          event.page == 1
              ? apiResponse.characters
              : [...state.characters, ...apiResponse.characters];

      emit(
        state.copyWith(
          status: CharactersListStatus.success,
          isSearch: false,
          characters:
              event.page == 1
                  ? apiResponse.characters
                  : [...state.characters, ...apiResponse.characters],
          currentPage: apiResponse.info.currentPage,
          totalPage: apiResponse.info.totalPage,
        ),
      );
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(
        state.copyWith(
          status: CharactersListStatus.error,
          errorMessage: 'Something went wrong',
        ),
      );
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _addFavorite(
    CharactersListToggleFavoriteEvent event,
    Emitter<CharactersListState> emit,
  ) async {
    try {
      final characters = List<Character>.from(state.characters);

      int index = characters.indexOf(event.character);

      if (index != -1) {
        characters[index] = characters[index].copyWith(
          isFavorite: !characters[index].isFavorite,
        );
        await repository.saveCharacter(characters[index]);
      } else {
        event.character.isFavorite = false;
        await repository.saveCharacter(event.character);
      }



      emit(
        state.copyWith(
          status: CharactersListStatus.success,
          characters: characters,
        ),
      );
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
    }
  }

  Future<void> _search(
    CharactersListSearchEvent event,
    Emitter<CharactersListState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CharactersListStatus.searching));

      final apiResponse = await repository.getCharactersByName(
        event.name,
        page: event.page,
      );

      emit(
        state.copyWith(
          status: CharactersListStatus.success,
          isSearch: true,
          characters:
              event.page == 1
                  ? apiResponse.characters
                  : [...state.characters, ...apiResponse.characters],
          currentPage: apiResponse.info.currentPage,
          totalPage: apiResponse.info.totalPage,
        ),
      );
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(
        state.copyWith(
          status: CharactersListStatus.error,
          errorMessage: 'Couldn\'t complete the search',
        ),
      );
    }
  }


}
