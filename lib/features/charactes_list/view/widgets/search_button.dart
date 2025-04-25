import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding:  EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.hintColor.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text('Search...'),
    );
  }
}
