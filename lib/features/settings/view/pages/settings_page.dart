import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/theme/bloc/theme_cubit.dart';
import 'package:rick_and_morty_characters/features/settings/view/widgets/settings_toggle_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = getIt<ThemeCubit>().state.isDark;
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            centerTitle: true,
            title: Text('Settings', style: theme.textTheme.headlineLarge),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: SettingsToggleCard(
              title: 'Dark theme',
              value: isDarkTheme,
              onChanged: _setThemeBrightness,
            ),
          ),
        ],
      ),
    );
  }

  void _setThemeBrightness(bool value) {
    getIt<ThemeCubit>().setThemeBrightness(
      value ? Brightness.dark : Brightness.light,
    );
  }
}
