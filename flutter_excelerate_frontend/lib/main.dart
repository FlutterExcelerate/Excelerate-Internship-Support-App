import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const LearnifyApp());
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
