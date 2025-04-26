import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/theme/theme.dart';
import 'package:rick_and_morty_characters/features/characters_list/bloc/characters_list_bloc.dart';
import 'package:rick_and_morty_characters/features/characters_list/view/pages/characters_list_page.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';
import 'package:rick_and_morty_characters/features/home_page.dart';

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CharactersListBloc>()),
        BlocProvider(create: (context) => getIt<FavoriteBloc>()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: HomePage(),
      ),
    );
  }
}
