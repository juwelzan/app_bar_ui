import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('ScrollResponsiveHeader', () {
    testWidgets('renders title, subtitle, welcome, and avatar correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ScrollResponsiveHeader(
              welcome: Text('Welcome back!'),
              title: Text('My Dashboard'),
              subtitle: Text('Manage your daily activities'),
              avatar: CircleAvatar(child: Text('U')),
            ),
          ),
        ),
      );

      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('My Dashboard'), findsOneWidget);
      expect(find.text('Manage your daily activities'), findsOneWidget);
      expect(find.text('U'), findsOneWidget);
    });

    testWidgets('renders custom content and actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollResponsiveHeader(
              title: const Text('Title'),
              actions: const [Icon(Icons.more_vert)],
              content: const ElevatedButton(
                onPressed: null,
                child: Text('Header Action'),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.text('Header Action'), findsOneWidget);
    });
  });
}
