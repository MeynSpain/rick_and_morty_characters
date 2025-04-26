import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_characters/core/const/status/characters_list_status.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';

part 'characters_list_event.dart';

part 'characters_list_state.dart';

class CharactersListBloc
    extends Bloc<CharactersListEvent, CharactersListState> {
  final CharactersRepository repository;

  CharactersListBloc({required this.repository})
    : super(CharactersListState.initial()) {
    on<CharactersListGetListEvent>(_getList);
  }

  Future<void> _getList(
    CharactersListGetListEvent event,
    Emitter<CharactersListState> emit,
  ) async {
    emit(state.copyWith(status: CharactersListStatus.loading));

    try {
      List<Character> characters = [];

      characters = await repository.getCharactersPage(event.page);

      emit(
        state.copyWith(
          status: CharactersListStatus.success,
          characters: characters,
        ),
      );
    } catch (e, st) {
      emit(
        state.copyWith(
          status: CharactersListStatus.error,
          errorMessage: 'Something went wrong',
        ),
      );
    }
  }
}
