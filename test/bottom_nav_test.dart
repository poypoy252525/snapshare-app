import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_project/bottom_nav_bar_page.dart';

void main() {
  testWidgets('Bottom navigation is visible on mobile width', (
    WidgetTester tester,
  ) async {
    // Set screen size to mobile width
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MaterialApp(home: BottomNavBarPage()));

    // Verify icons are present
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.message), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Verify labels are empty strings (icon only)
    final BottomNavigationBar navBar = tester.widget(
      find.byType(BottomNavigationBar),
    );
    for (var item in navBar.items) {
      expect(item.label, equals(''));
    }
    expect(navBar.showSelectedLabels, isFalse);
    expect(navBar.showUnselectedLabels, isFalse);

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('Bottom navigation is hidden on desktop width', (
    WidgetTester tester,
  ) async {
    // Set screen size to desktop width
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MaterialApp(home: BottomNavBarPage()));

    // Verify BottomNavigationBar is NOT present
    expect(find.byType(BottomNavigationBar), findsNothing);

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
