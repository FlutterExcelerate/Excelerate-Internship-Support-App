import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LearnifyApp());
}

void runApp(LearnifyApp learnifyApp) {
}

class LearnifyApp extends StatelessWidget {
  const LearnifyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learnify',
      debugShowCheckedModeBanner: false,
      theme: LearnifyTheme.light(),
      home: const LoginScreen(),
    );
  }
}

mixin Widget {
}

mixin BuildContext {
}

class StatelessWidget {
}
