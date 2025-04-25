import 'package:flutter/material.dart';

// const _primaryColor = Color(0xFFE4A788); // Один из вариантов (Такао)
// const _primaryColor = Color(0xFFF0E14A);  // (Звездолет)
// const _primaryColor = Color(0xFF97CE4C);  // (Хвойное дерево)
const _primaryColor = Color(0xFFE89AC7);  // (Коби)

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor, brightness: Brightness.light),
);