import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('PinnedActionButton', () {
    testWidgets('renders initial widget when progress is 0.0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(
                Icons.person,
                key: ValueKey('initial_avatar'),
              ),
              scrolledWidget: const Icon(
                Icons.menu,
                key: ValueKey('scrolled_drawer'),
              ),
              progress: 0.0,
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('initial_avatar')), findsOneWidget);
      expect(find.byKey(const ValueKey('scrolled_drawer')), findsOneWidget);

      // Verify opacity: initial is 1.0, scrolled is 0.0
      final opacities = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .toList();
      expect(opacities.length, 2);
      expect(opacities[0].opacity, 1.0);
      expect(opacities[1].opacity, 0.0);
    });

    testWidgets('renders scrolled widget when progress is 1.0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(
                Icons.person,
                key: ValueKey('initial_avatar'),
              ),
              scrolledWidget: const Icon(
                Icons.menu,
                key: ValueKey('scrolled_drawer'),
              ),
              progress: 1.0,
            ),
          ),
        ),
      );

      final opacities = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .toList();
      expect(opacities.length, 2);
      expect(opacities[0].opacity, 0.0);
      expect(opacities[1].opacity, 1.0);
    });

    testWidgets(
      'maintains fixed touch target dimensions without layout shift',
      (tester) async {
        const targetSize = Size(48.0, 48.0);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PinnedActionButton(
                initialWidget: const Icon(Icons.person),
                scrolledWidget: const Icon(Icons.menu),
                progress: 0.5,
                touchTargetSize: targetSize,
              ),
            ),
          ),
        );

        final renderBox = tester.renderObject<RenderBox>(
          find.byType(PinnedActionButton),
        );
        expect(renderBox.size.width, targetSize.width);
        expect(renderBox.size.height, targetSize.height);
      },
    );

    testWidgets('has completely transparent background and no shadow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(Icons.person),
              scrolledWidget: const Icon(Icons.menu),
              progress: 0.0,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(PinnedActionButton),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, Colors.transparent);
      expect(decoration?.boxShadow, isEmpty);
    });

    testWidgets('triggers onInitialTap when progress < 0.5', (tester) async {
      bool initialTapped = false;
      bool scrolledTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(Icons.person),
              scrolledWidget: const Icon(Icons.menu),
              progress: 0.2,
              onInitialTap: () => initialTapped = true,
              onScrolledTap: () => scrolledTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PinnedActionButton));
      await tester.pump();

      expect(initialTapped, isTrue);
      expect(scrolledTapped, isFalse);
    });

    testWidgets('triggers onScrolledTap when progress >= 0.5', (tester) async {
      bool initialTapped = false;
      bool scrolledTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(Icons.person),
              scrolledWidget: const Icon(Icons.menu),
              progress: 0.8,
              onInitialTap: () => initialTapped = true,
              onScrolledTap: () => scrolledTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PinnedActionButton));
      await tester.pump();

      expect(initialTapped, isFalse);
      expect(scrolledTapped, isTrue);
    });

    testWidgets('semantics label updates correctly based on progress state', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinnedActionButton(
              initialWidget: const Icon(Icons.person),
              scrolledWidget: const Icon(Icons.menu),
              progress: 0.1,
              semanticLabelInitial: 'Profile',
              semanticLabelScrolled: 'Open Menu',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Profile'), findsOneWidget);
      expect(find.bySemanticsLabel('Open Menu'), findsNothing);
    });
  });
}
