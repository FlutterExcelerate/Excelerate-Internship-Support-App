import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LearnifyApp());
}

class LearnifyApp extends StatefulWidget {
  const LearnifyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  @override
  State<LearnifyApp> createState() => _LearnifyAppState();
}

class _LearnifyAppState extends State<LearnifyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: LearnifyApp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Learnify',
          debugShowCheckedModeBanner: false,
          theme: LearnifyTheme.light(),
          darkTheme: LearnifyTheme.dark(),
          themeMode: currentMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}
