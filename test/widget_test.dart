
import 'package:flutter_test/flutter_test.dart';

import 'package:learnify_app/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnifyApp());
    expect(find.text('Theme + toggle working ✅'), findsOneWidget);
  });
}