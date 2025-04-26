import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/const/status/characters_list_status.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/character_card.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/widgets/search_button.dart';

class CharactersListPage extends StatefulWidget {
  const CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  @override
  void initState() {
    getIt<CharactersListBloc>().add(CharactersListGetListEvent(page: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          getIt<CharactersListBloc>().add(CharactersListGetListEvent(page: 1));
        },
        icon: Icon(Icons.download),
        color: theme.primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            // backgroundColor: theme.primaryColor,
            title: Text('Rick and Morty'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: SearchButton(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          BlocBuilder<CharactersListBloc, CharactersListState>(
            bloc: getIt<CharactersListBloc>(),
            builder: (context, state) {
              if (state.status == CharactersListStatus.success) {
                return SliverList.builder(
                  itemCount: state.characters.length,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CharacterCard(
                          character: state.characters[index],
                          onFavoriteTap: () {},
                        ),
                      ),
                );
              }
              if (state.status == CharactersListStatus.loading ||
                  state.status == CharactersListStatus.initial) {
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
    );
  }
}
