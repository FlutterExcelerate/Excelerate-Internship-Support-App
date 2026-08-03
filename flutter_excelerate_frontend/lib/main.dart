import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/auth_gate.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/firebase_options.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_session_guard.dart';
import 'package:flutter_excelerate_frontend/utils/responsive.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdminSessionGuard.init();

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
    return ListenableBuilder(
      listenable: LearnifyApp.themeNotifier,
      builder: (_, __) {
        return MaterialApp(
          navigatorKey: LearnifyApp.navigatorKey,
          title: 'Learnify',
          debugShowCheckedModeBanner: false,
          theme: LearnifyTheme.light(),
          darkTheme: LearnifyTheme.dark(),
          themeMode: LearnifyApp.themeNotifier.value,
          builder: (context, child) {
            return ResponsiveAppBuilder(child: child ?? const SizedBox.shrink());
          },
          home: const AuthGate(),
        );
      },
    );
  }
}
