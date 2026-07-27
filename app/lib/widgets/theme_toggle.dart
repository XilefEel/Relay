import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';

IconData _iconForMode(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
    ThemeMode.system => Icons.brightness_auto,
  };
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      icon: Icon(_iconForMode(themeController.mode), size: 20),
      onSelected: themeController.setMode,
      itemBuilder: (context) => [
        _themeMenuItem(
          context,
          ThemeMode.light,
          'Light',
          Icons.light_mode,
          themeController.mode == ThemeMode.light,
        ),
        _themeMenuItem(
          context,
          ThemeMode.dark,
          'Dark',
          Icons.dark_mode,
          themeController.mode == ThemeMode.dark,
        ),
        _themeMenuItem(
          context,
          ThemeMode.system,
          'System',
          Icons.brightness_auto,
          themeController.mode == ThemeMode.system,
        ),
      ],
    );
  }
}

PopupMenuItem<ThemeMode> _themeMenuItem(
  BuildContext context,
  ThemeMode mode,
  String label,
  IconData icon,
  bool isSelected,
) {
  return PopupMenuItem(
    value: mode,
    child: Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 12),
        Text(label),
        const Spacer(),
        isSelected
            ? Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              )
            : const SizedBox(width: 16),
      ],
    ),
  );
}
