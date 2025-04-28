import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/const/status/favorite_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          getIt<FavoriteBloc>().add(FavoriteGetCharactersEvent());
        },
        icon: Icon(Icons.download),
        color: theme.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          getIt<FavoriteBloc>().add(
            FavoriteGetCharactersEvent(completer: completer),
          );
          return completer.future;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              // backgroundColor: theme.primaryColor,
              title: Text('Rick and Morty', style: theme.textTheme.headlineLarge,),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => _showSortBottomSheet(context),
                  icon: Icon(Icons.sort),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: SearchButton(),
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
                            onFavoriteTap: () {
                              final character = state.favoriteCharacters[index];
                              getIt<FavoriteBloc>().add(
                                FavoriteToggleEvent(character: character),
                              );
                              getIt<CharactersListBloc>().add(
                                CharactersListToggleFavoriteEvent(
                                  character: character,
                                ),
                              );
                            },
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
          ],
        ),
      ),
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

  @override
  bool get wantKeepAlive => true;
}
