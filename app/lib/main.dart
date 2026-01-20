import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'config/supabase_config.dart';
import 'features/home/presentation/pages/home_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (if configured)
  await SupabaseConfig.initialize();

  runApp(const AnthropoReaderApp());
}

class AnthropoReaderApp extends StatelessWidget {
  const AnthropoReaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Anthropo Reader',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const HomeShell(),
          );
        },
      ),
    );
  }
}
