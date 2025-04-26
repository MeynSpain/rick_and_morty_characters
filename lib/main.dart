import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/core/rick_and_morty_app.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const RickAndMortyApp());
}
