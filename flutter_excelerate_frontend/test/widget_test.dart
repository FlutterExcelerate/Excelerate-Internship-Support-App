import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_excelerate_frontend/main.dart';

void main() {
  testWidgets('Learnify login screen renders primary entry points', (
    tester,
  ) async {
    await tester.pumpWidget(const LearnifyApp());

    expect(find.text('Learnify'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
    expect(find.text('Admin Login'), findsOneWidget);
  });
}
