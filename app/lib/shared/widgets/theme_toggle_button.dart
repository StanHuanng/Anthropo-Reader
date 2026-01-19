import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isParchmentMode
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
          ),
          tooltip: themeProvider.isParchmentMode ? 'Switch to Pitch Black' : 'Switch to Parchment',
          onPressed: () => themeProvider.toggleTheme(),
        );
      },
    );
  }
}
