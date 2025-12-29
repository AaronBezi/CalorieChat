// CalorieChat Widget Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calorie_chat/main.dart';
import 'package:calorie_chat/core/config/env.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Env.load();
    } catch (e) {
      // .env file may not exist in test environment
    }
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify that bottom navigation exists (use findsWidgets for flexibility)
    expect(find.text('Search'), findsAtLeastNWidgets(1));
    expect(find.text('Chat'), findsAtLeastNWidgets(1));
    expect(find.text('Insights'), findsAtLeastNWidgets(1));

    // Verify navigation bar itself exists
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
