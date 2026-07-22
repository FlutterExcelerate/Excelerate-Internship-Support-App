import 'home_screen.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

void main() {
  runApp(const LearnifyApp());
}

class LearnifyApp extends StatelessWidget {
  const LearnifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Learnify',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}

/// Temporary placeholder screen — will be replaced once we build
/// the real Login screen. This just lets us verify theme + toggle work.
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learnify'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: () {
              themeModeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Theme + toggle working ✅',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}