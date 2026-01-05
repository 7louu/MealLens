// Basic smoke test to ensure app launches without crashing

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that MaterialApp is created
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
