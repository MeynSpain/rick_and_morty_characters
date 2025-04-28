import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;
  final TextEditingController controller;
  bool isSearching;

  SearchButton({
    super.key,
    required this.onSearch,
    required this.onClear,
    required this.controller,
    required this.isSearching,
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.hintColor.withAlpha(30),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          widget.isSearching
              ? CircularProgressIndicator()
              : Icon(Icons.search, color: theme.hintColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: theme.hintColor),
              ),
              style: theme.textTheme.bodyMedium,
              onSubmitted:
                  (_) => widget.onSearch(widget.controller.text.trim()),
            ),
          ),

          IconButton(onPressed: widget.onClear, icon: Icon(Icons.clear)),
        ],
      ),
    );
  }
}
