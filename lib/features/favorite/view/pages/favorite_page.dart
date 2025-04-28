import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/const/status/favorite_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/character_card.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/search_button.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';
import 'package:rick_and_morty_characters/features/favorite/view/widgets/sort_bottom_sheet.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {
  String _searchText = '';
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          if (_searchController.text.isEmpty) {
            getIt<FavoriteBloc>().add(
              FavoriteGetCharactersEvent(completer: completer),
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
              actions: [
                IconButton(
                  onPressed: () => _showSortBottomSheet(context),
                  icon: Icon(Icons.sort),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: SearchButton(
                  isSearching: false,
                  controller: _searchController,
                  onSearch: (value) => _onSearch(value),
                  onClear: _onClear,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            BlocBuilder<FavoriteBloc, FavoriteState>(
              bloc: getIt<FavoriteBloc>(),
              builder: (context, state) {
                if (state.status == FavoriteStatus.success) {
                  return SliverList.builder(
                    itemCount: state.favoriteCharacters.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CharacterCard(
                            character: state.favoriteCharacters[index],
                            onFavoriteTap:
                                () => _onFavoriteTap(
                                  state.favoriteCharacters[index],
                                ),
                          ),
                        ),
                  );
                }
                if (state.status == FavoriteStatus.loading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state.status == FavoriteStatus.error) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.errorMessage)),
                  );
                }
                return SliverFillRemaining();
              },
            ),
            // Чтобы Рефреш индикатор работал
            SliverFillRemaining(
              child: Center(child: Text('No more characters load')),
            ),
          ],
        ),
      ),
    );
  }

  void _onFavoriteTap(Character character) {
    getIt<FavoriteBloc>().add(FavoriteToggleEvent(character: character));
    getIt<CharactersListBloc>().add(
      CharactersListToggleFavoriteEvent(character: character),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(child: SortBottomSheet());
      },
    );
  }

  void _onClear({Completer? completer}) {
    if (_searchText.isNotEmpty) {
      _searchText = '';
      _searchController.clear();

      getIt<FavoriteBloc>().add(
        FavoriteGetCharactersEvent(completer: completer),
      );

      _scrollToTop();
    }
  }

  void _onSearch(text) {
    if (text.isNotEmpty) {
      _searchText = text;
      getIt<FavoriteBloc>().add(FavoriteSearchEvent(name: _searchText));

      _scrollToTop();
    }
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
