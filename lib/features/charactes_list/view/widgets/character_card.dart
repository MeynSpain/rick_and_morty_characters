import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/model/character.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback onFavoriteTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteTap,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(character.image),
              radius: 30,
            ),
            title: Text(character.name),
            subtitle: Text('${character.species} - ${character.status}'),
            trailing: IconButton(
              onPressed: widget.onFavoriteTap,
              icon:
                  character.isFavorite
                      ? Icon(Icons.star)
                      : Icon(Icons.star_border),
              color: character.isFavorite ? Colors.amber : null,
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            firstCurve: Curves.easeInOut,
            secondCurve: Curves.easeIn,
            firstChild: SizedBox(),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            secondChild:
                _isExpanded
                    ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type - ${character.type.isNotEmpty ? character.type : 'Unknown'}',
                          ),
                          Text('Gender - ${character.gender}'),
                          Text('Origin - ${character.origin}'),
                        ],
                      ),
                    )
                    : SizedBox(),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
