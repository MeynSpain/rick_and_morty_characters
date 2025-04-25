import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';
import 'package:rick_and_morty_characters/core/repositories/characters_repository/characters_repositories.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharactersRepository repository = CharactersRepository();

  List<Character> characters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () async {
          characters = await repository.getCharactersPage(1);
          print(characters.length);
          setState(() {});
        },
        icon: Icon(Icons.add),
      ),
      body:
          characters.isEmpty
              ? Center(child: Text('Не загружено'))
              : ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final character = characters[index];
                  return Text(character.name);
                },
              ),
    );
  }
}
