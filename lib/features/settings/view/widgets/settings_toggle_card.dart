import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsToggleCard extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsToggleCard({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              Switch(
                value: value,
                onChanged: onChanged,
                // activeColor: Colors.green,
                // inactiveTrackColor: Colors.red,
                // inactiveThumbColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
