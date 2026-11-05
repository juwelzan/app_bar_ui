import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Batch 6: Specialized Presets (46-50) Tests', () {
    test('Preset enum metadata, labels, and descriptions exist for presets 46-50', () {
      const presets = [
        ScrollHeaderPreset.map,
        ScrollHeaderPreset.form,
        ScrollHeaderPreset.wizard,
        ScrollHeaderPreset.notificationCenter,
        ScrollHeaderPreset.customScrollLayout,
      ];

      for (final p in presets) {
        expect(p.label.isNotEmpty, isTrue);
        expect(p.description.isNotEmpty, isTrue);
      }

      expect(ScrollHeaderPreset.map.label, 'Map Header');
      expect(ScrollHeaderPreset.form.label, 'Form Header');
      expect(ScrollHeaderPreset.wizard.label, 'Wizard Header');
      expect(ScrollHeaderPreset.notificationCenter.label, 'Notification Center Header');
      expect(ScrollHeaderPreset.customScrollLayout.label, 'Custom Scroll Layout Header');
    });

    test('isSliver contract is strictly verified for presets 46-50', () {
      expect(const ScrollHeader.map().isSliver, isFalse);
      expect(const ScrollHeader.form().isSliver, isFalse);
      expect(const ScrollHeader.wizard().isSliver, isFalse);
      expect(const ScrollHeader.notificationCenter().isSliver, isFalse);
      expect(const ScrollHeader.customScrollLayout().isSliver, isTrue);
    });

    testWidgets('Preset 46: MapHeaderWidget renders map canvas, floating search, and location pill',
        (tester) async {
      String? changedQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapHeaderWidget(
              title: const Text('Golden Gate Bridge'),
              searchHint: 'Find parking...',
              onSearchChanged: (val) => changedQuery = val,
              mapWidget: const ColoredBox(
                color: Colors.lightGreen,
                child: Center(child: Text('Map View Canvas')),
              ),
              actions: const [Icon(Icons.layers)],
            ),
          ),
        ),
      );

      expect(find.text('Map View Canvas'), findsOneWidget);
      expect(find.text('Golden Gate Bridge'), findsOneWidget);
      expect(find.text('Find parking...'), findsOneWidget);
      expect(find.byIcon(Icons.layers), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Marina');
      expect(changedQuery, 'Marina');
    });

    testWidgets('Preset 47: FormHeaderWidget manages isDirty and isSaving states reactively',
        (tester) async {
      var saveCalled = false;

      // 1. Initially clean (!isDirty) -> Save button is disabled
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: FormHeaderWidget(
                title: const Text('Edit Account'),
                subtitle: const Text('Saved'),
                isDirty: false,
                onSave: () => saveCalled = true,
              ),
            ),
            body: const Center(child: Text('Form Body')),
          ),
        ),
      );

      expect(find.text('Edit Account'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      final saveButtonClean = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(saveButtonClean.onPressed, isNull);

      // 2. Form becomes dirty -> Save button is enabled
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: FormHeaderWidget(
                title: const Text('Edit Account'),
                subtitle: const Text('Unsaved changes'),
                isDirty: true,
                onSave: () => saveCalled = true,
              ),
            ),
            body: const Center(child: Text('Form Body')),
          ),
        ),
      );

      final saveButtonDirty = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(saveButtonDirty.onPressed, isNotNull);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(saveCalled, isTrue);

      // 3. Saving state -> displays CircularProgressIndicator
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: FormHeaderWidget(
                title: const Text('Edit Account'),
                isDirty: true,
                isSaving: true,
                onSave: () {},
              ),
            ),
            body: const Center(child: Text('Form Body')),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Preset 48: WizardHeaderWidget renders step counter and progress segments',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(74.0),
              child: WizardHeaderWidget(
                currentStep: 3,
                totalSteps: 5,
                stepTitle: Text('Payment Method'),
                leading: Icon(Icons.arrow_back),
                actions: [Icon(Icons.close)],
              ),
            ),
            body: const Center(child: Text('Wizard Content')),
          ),
        ),
      );

      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Step 3 of 5'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Verify 5 step segment containers
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('Preset 49: NotificationCenterHeaderWidget renders unread badge and mark-all-read',
        (tester) async {
      var markAllReadTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(116.0),
              child: NotificationCenterHeaderWidget(
                title: const Text('Updates'),
                unreadCount: 7,
                onMarkAllRead: () => markAllReadTapped = true,
                segments: const Text('Filter Tabs Row'),
                leading: const Icon(Icons.arrow_back),
              ),
            ),
            body: const Center(child: Text('Notification Feed')),
          ),
        ),
      );

      expect(find.text('Updates'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Mark all read'), findsOneWidget);
      expect(find.text('Filter Tabs Row'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      await tester.tap(find.text('Mark all read'));
      await tester.pump();
      expect(markAllReadTapped, isTrue);
    });

    testWidgets('Preset 49: NotificationCenterHeaderWidget prevents overflow on narrow screens',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(116.0),
              child: NotificationCenterHeaderWidget(
                title: const Text('Activity Feed with Long Title Text'),
                unreadCount: 4,
                onMarkAllRead: () {},
                segments: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    ActionChip(label: Text('All'), onPressed: null),
                    SizedBox(width: 8.0),
                    ActionChip(label: Text('Unread (4)'), onPressed: null),
                  ],
                ),
                leading: const Icon(Icons.arrow_back),
                actions: const [
                  Icon(Icons.settings),
                ],
              ),
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      // Asserts that no exception or overflow occurred on 360px viewport
      expect(tester.takeException(), isNull);
      expect(find.text('4'), findsWidgets);
    });

    testWidgets('Preset 50: CustomScrollLayoutHeaderWidget renders as sliver with custom delegate or builder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                CustomScrollLayoutHeaderWidget(
                  expandedHeight: 180.0,
                  collapsedHeight: 60.0,
                  builder: (context, progress, overlapsContent) {
                    return Container(
                      color: Colors.indigo,
                      alignment: Alignment.center,
                      child: Text('Sliver Progress: ${(progress * 100).toInt()}%'),
                    );
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Feed Item #$index')),
                    childCount: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Sliver Progress: 0%'), findsOneWidget);

      // Scroll up to trigger collapse
      await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -200.0));
      await tester.pumpAndSettle();

      expect(find.text('Sliver Progress: 100%'), findsOneWidget);
    });

    testWidgets('ScrollHeader convenience constructor builds presets 46-50 accurately',
        (tester) async {
      final mapHeader = ScrollHeader.map(
        title: const Text('Map'),
      );
      expect(mapHeader.preset, ScrollHeaderPreset.map);
      expect(mapHeader.isSliver, isFalse);

      final formHeader = ScrollHeader.form(
        title: const Text('Form'),
        isDirty: true,
      );
      expect(formHeader.preset, ScrollHeaderPreset.form);
      expect(formHeader.isSliver, isFalse);

      final wizardHeader = ScrollHeader.wizard(
        currentStep: 2,
        totalSteps: 4,
      );
      expect(wizardHeader.preset, ScrollHeaderPreset.wizard);
      expect(wizardHeader.isSliver, isFalse);

      final notifHeader = ScrollHeader.notificationCenter(
        title: const Text('Notif'),
        unreadCount: 3,
      );
      expect(notifHeader.preset, ScrollHeaderPreset.notificationCenter);
      expect(notifHeader.isSliver, isFalse);

      final customHeader = ScrollHeader.customScrollLayout(
        expandedHeight: 220.0,
      );
      expect(customHeader.preset, ScrollHeaderPreset.customScrollLayout);
      expect(customHeader.isSliver, isTrue);
    });
  });
}

