import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_excelerate_frontend/firebase/screen/login_screen.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';

void main() {
  testWidgets('Learnify login screen renders primary entry points', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: LearnifyTheme.light(),
        darkTheme: LearnifyTheme.dark(),
        home: const LoginScreen(),
      ),
    );

    expect(find.text('Learnify'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue as Admin'), findsOneWidget);
  });
}
