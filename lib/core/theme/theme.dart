import 'package:flutter/material.dart';

// const _primaryColor = Color(0xFFE4A788); // Один из вариантов (Такао)
// const _primaryColor = Color(0xFFF0E14A);  // (Звездолет)
// const _primaryColor = Color(0xFF97CE4C);  // (Хвойное дерево)
const _primaryColor = Color(0xFFE89AC7); // (Коби)

final themeData = ThemeData(
  useMaterial3: true,
  primaryColor: _primaryColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
  ),

  textTheme: _textTheme,
);

final darkTheme = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.dark,
  ),
  bottomNavigationBarTheme: _bottomNavigationBarTheme,
);

final lightTheme = ThemeData(
  useMaterial3: true,
  textTheme: _textTheme,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
  ),
  cardColor: _primaryColor.withAlpha(100),
  bottomNavigationBarTheme: _bottomNavigationBarTheme,
);

final _textTheme = const TextTheme(
  headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
);

final _bottomNavigationBarTheme = BottomNavigationBarThemeData(
  selectedItemColor: _primaryColor,

);
