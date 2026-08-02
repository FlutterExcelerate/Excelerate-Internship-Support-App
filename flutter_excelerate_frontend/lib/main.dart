import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/auth_gate.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LearnifyApp());
}

class LearnifyApp extends StatefulWidget {
  const LearnifyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
          navigatorKey: LearnifyApp.navigatorKey,
          title: 'Learnify',
          debugShowCheckedModeBanner: false,
          theme: LearnifyTheme.light(),
          darkTheme: LearnifyTheme.dark(),
          themeMode: currentMode,
          home: const AuthGate(),
        );
      },
    );
  }
}
