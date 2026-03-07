// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_project/main.dart';

void main() {
  testWidgets('Bottom navigation home page smoke test', (
    WidgetTester tester,
  ) async {
    // Set screen size to mobile width
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our home page text is present.
    expect(find.text('Home Page'), findsOneWidget);

    // Verify icons are present
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.message), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
