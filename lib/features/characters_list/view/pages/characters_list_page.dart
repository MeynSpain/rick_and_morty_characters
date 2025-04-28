import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/const/status/characters_list_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/character_card.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/search_button.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final currentState = getIt<CharactersListBloc>().state;

    if (currentState.status == CharactersListStatus.loading) return;

    if (currentScroll >= maxScroll) {
      if (currentState.status == CharactersListStatus.success &&
          currentState.currentPage < currentState.totalPage) {
        if (currentState.status == CharactersListStatus.loading) return;

        if (currentState.isSearch) {
          getIt<CharactersListBloc>().add(
            CharactersListSearchEvent(
              name: _searchText,
              page: currentState.currentPage + 1,
            ),
          );
        } else {
          getIt<CharactersListBloc>().add(
            CharactersListGetListEvent(page: currentState.currentPage + 1),
          );
        }

        Future.delayed(Duration(milliseconds: 50), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 100,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();

          if (_searchController.text.isEmpty) {
            getIt<CharactersListBloc>().add(
              CharactersListGetListEvent(page: 1, completer: completer),
            );
          } else {
            _onClear(completer: completer);
          }
          return completer.future;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              title: Text(
                'Rick and Morty',
                style: theme.textTheme.headlineLarge,
              ),
              centerTitle: true,
              expandedHeight: 150,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: BlocBuilder<CharactersListBloc, CharactersListState>(
                  builder: (context, state) {
                    return SearchButton(
                      isSearching:
                          getIt<CharactersListBloc>().state.status ==
                          CharactersListStatus.searching,
                      controller: _searchController,
                      onSearch: _onSearch,
                      onClear: _onClear,
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            BlocConsumer<CharactersListBloc, CharactersListState>(
              listener: _handleCharacterListState,
              bloc: getIt<CharactersListBloc>(),
              builder: (context, state) {
                if (state.status == CharactersListStatus.success ||
                    state.status == CharactersListStatus.loading ||
                state.status == CharactersListStatus.searching) {
                  return SliverList.builder(
                    itemCount:
                        state.status == CharactersListStatus.loading ||
                                state.currentPage == state.totalPage
                            ? state.characters.length +
                                1 // +1 для индикатора загрузки
                            : state.characters.length,
                    itemBuilder: (context, index) {
                      if (index == state.characters.length &&
                          state.status == CharactersListStatus.loading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (index == state.characters.length &&
                          state.currentPage >= state.totalPage) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'No more characters load',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CharacterCard(
                          character: state.characters[index],
                          onFavoriteTap:
                              () => _onFavoriteTap(state.characters[index]),
                        ),
                      );
                    },
                  );
                }
                if (state.status == CharactersListStatus.loading &&
                    state.characters.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.status == CharactersListStatus.error) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.errorMessage)),
                  );
                }
                return SliverFillRemaining();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onClear({Completer? completer}) {
    if (_searchText.isNotEmpty) {
      _searchText = '';
      _searchController.clear();
      getIt<CharactersListBloc>().add(
        CharactersListGetListEvent(page: 1, completer: completer),
      );

      _scrollToTop();
    }
  }

  _onSearch(text) {
    if (_searchController.text.trim().isNotEmpty) {
      _searchText = text;
      getIt<CharactersListBloc>().add(
        CharactersListSearchEvent(name: _searchText, page: 1),
      );

      _scrollToTop();
    }
  }

  void _onFavoriteTap(Character character) {
    getIt<CharactersListBloc>().add(
      CharactersListToggleFavoriteEvent(character: character),
    );
  }

  void _handleCharacterListState(
    BuildContext context,
    CharactersListState state,
  ) {
    getIt<FavoriteBloc>().add(FavoriteGetCharactersEvent());
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
