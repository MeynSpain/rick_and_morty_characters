import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/theme/bloc/theme_cubit.dart';
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
      // Я знаю что добавлять в провайдер все эти блоки излишне, потому что я
      // зарегистрировал их в getIt, но это не вызывает проблем, потому что
      // я передаю сюда уже созданные экземпляры блоков.
      providers: [
        BlocProvider(create: (context) => getIt<CharactersListBloc>()),
        BlocProvider(create: (context) => getIt<FavoriteBloc>()),
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
      ],

      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.isDark ? darkTheme : lightTheme,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
