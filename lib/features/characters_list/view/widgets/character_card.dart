import 'package:cached_network_image/cached_network_image.dart';
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

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final character = widget.character;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipOval(
              child: CachedNetworkImage(
                imageUrl: character.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),

            title: Text(
              '${character.id} - ${character.name}',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              '${character.species} - ${character.status}',
              style: theme.textTheme.titleSmall,
            ),
            trailing: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: IconButton(
                    onPressed: () {
                      _animationController.forward().then(
                        (_) => _animationController.reverse(),
                      );
                      widget.onFavoriteTap();
                    },
                    icon:
                        character.isFavorite
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                    color: character.isFavorite ? Colors.amber : null,
                  ),
                );
              },
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
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'Gender - ${character.gender}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'Origin - ${character.origin}',
                            style: theme.textTheme.bodyMedium,
                          ),
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
