import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';
import 'package:rick_and_morty_characters/features/charactes_list/view/widgets/character_card.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Text('data'),
         
    );
  }
}
