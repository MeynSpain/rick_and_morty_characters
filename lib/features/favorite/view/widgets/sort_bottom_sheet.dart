import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_characters/core/init.dart';
import 'package:rick_and_morty_characters/features/favorite/bloc/favorite_bloc.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({super.key});

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  List<String> options = [
    'Id',
    'Name',
    'Status',
    'Species',
    'Type',
    'Gender',
    'Origin',
  ];

  late String _currentOption;
  bool _isAscending = true;

  @override
  void initState() {
    _currentOption = getIt<FavoriteBloc>().state.currentOption;
    _isAscending = getIt<FavoriteBloc>().state.isAscending;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sort by', style: theme.textTheme.bodyMedium),
          ...List.generate(options.length, (index) {
            return RadioListTile(
              title: Text(options[index]),
              value: options[index],
              groupValue: _currentOption,
              onChanged: (value) {
                setState(() {
                  _currentOption = value!;
                  getIt<FavoriteBloc>().add(
                    FavoriteSortEvent(
                      sortOption: _currentOption,
                      isAscending: _isAscending,
                    ),
                  );
                });
              },
            );
          }),
          Divider(),
          RadioListTile(
            title: Text('Descending order'),
            value: false,
            groupValue: _isAscending,
            onChanged: (value) {
              setState(() {
                _isAscending = value!;
                getIt<FavoriteBloc>().add(
                  FavoriteSortEvent(
                    sortOption: _currentOption,
                    isAscending: _isAscending,
                  ),
                );
              });
            },
          ),
          RadioListTile(
            title: Text('Ascending order'),
            value: true,
            groupValue: _isAscending,
            onChanged: (value) {
              setState(() {
                _isAscending = value!;
                getIt<FavoriteBloc>().add(
                  FavoriteSortEvent(
                    sortOption: _currentOption,
                    isAscending: _isAscending,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
