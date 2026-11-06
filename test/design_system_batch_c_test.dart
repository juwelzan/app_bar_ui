import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bar_ui/app_bar_ui.dart';

void main() {
  group('Complete AppBar Design System — Batch C: Models 9–12 Tests', () {
    testWidgets(
      'Model 9: EditorialTypographyHeaderWidget renders masthead and collapses headline with reading progress',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const EditorialTypographyHeaderWidget(
                    config: EditorialTypographyConfig(
                      headline: 'The Architecture of Thought',
                      editionNumber: 'Vol IV • Issue 12',
                      publicationDate: 'November 2026',
                      category: 'Systems Engineering',
                      expandedHeight: 220.0,
                      collapsedHeight: 60.0,
                      showReadingProgressBar: true,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Paragraph $index')),
                      childCount: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Category, Edition, Headline are visible
        expect(find.text('SYSTEMS ENGINEERING'), findsOneWidget);
        expect(find.text('Vol IV • Issue 12 • November 2026'), findsOneWidget);
        expect(find.text('The Architecture of Thought'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Scroll down to collapse into compact masthead
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -180.0));
        await tester.pumpAndSettle();

        // Collapsed state: Compact masthead category and headline visible
        expect(find.text('SYSTEMS ENGINEERING'), findsOneWidget);
        expect(find.text('The Architecture of Thought'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 10: CardDeckStackedHeaderWidget renders fanned card stack and tucks into compact consolidated card bar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const CardDeckStackedHeaderWidget(
                    config: CardDeckStackedConfig(
                      deckTitle: 'Executive Wallet',
                      cards: [
                        DeckCardItem(
                          title: 'Black Obsidian Card',
                          subtitle: '•••• 7712 • Exp 12/29',
                          icon: Icons.credit_card,
                          badge: 'Primary',
                        ),
                        DeckCardItem(
                          title: 'Venture Metal Card',
                          subtitle: '•••• 3301 • Exp 04/28',
                          icon: Icons.flight,
                          badge: 'Rewards',
                        ),
                      ],
                      expandedHeight: 210.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Transaction $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: Deck title, card count badge, and card items visible
        expect(find.text('Executive Wallet'), findsOneWidget);
        expect(find.text('2 Cards'), findsOneWidget);
        expect(find.text('Black Obsidian Card'), findsOneWidget);
        expect(find.text('Venture Metal Card'), findsOneWidget);

        // Scroll down to tuck and collapse into consolidated card bar
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -170.0));
        await tester.pumpAndSettle();

        // Collapsed state: Active card title and badge rendered in compact bar
        expect(find.text('Black Obsidian Card'), findsOneWidget);
        expect(find.text('Primary'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 11: MinimalistMicroBarHeaderWidget renders razor-thin breadcrumb, status and progress dot',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const MinimalistMicroBarHeaderWidget(
                    config: MinimalistMicroBarConfig(
                      pathBreadcrumb: 'packages / app_bar_ui / lib / engine.dart',
                      readingEta: '4 min read',
                      documentStatus: 'v2.4.0 • clean',
                      expandedHeight: 48.0,
                      collapsedHeight: 38.0,
                      showProgressDot: true,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Code line $index')),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded micro-bar: Breadcrumb, reading ETA and status visible
        expect(find.text('packages / app_bar_ui / lib / engine.dart'), findsOneWidget);
        expect(find.text('4 min read'), findsOneWidget);
        expect(find.text('v2.4.0 • clean'), findsOneWidget);

        // Scroll down slightly
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -20.0));
        await tester.pumpAndSettle();

        // Pinning retains breadcrumb cleanly
        expect(find.text('packages / app_bar_ui / lib / engine.dart'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Model 12: ProfileIdentityHeaderWidget renders large centered avatar and morphs into compact inline toolbar slot',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  const ProfileIdentityHeaderWidget(
                    config: ProfileIdentityConfig(
                      userName: 'Dr. Eleanor Vance',
                      userHandle: '@eleanor_vance',
                      bio: 'Principal Systems Architect',
                      statChips: ['4.2k Followers', '280 Repos'],
                      verified: true,
                      expandedHeight: 210.0,
                      collapsedHeight: 60.0,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(title: Text('Activity $index')),
                      childCount: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Expanded state: User name, handle, bio, and stat chips
        expect(find.text('Dr. Eleanor Vance'), findsOneWidget);
        expect(find.text('@eleanor_vance'), findsOneWidget);
        expect(find.text('Principal Systems Architect'), findsOneWidget);
        expect(find.text('4.2k Followers'), findsOneWidget);
        expect(find.text('280 Repos'), findsOneWidget);

        // Scroll down past collapse threshold
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -170.0));
        await tester.pumpAndSettle();

        // Collapsed state: Compact toolbar with inline avatar slot and name
        expect(find.text('Dr. Eleanor Vance'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Universal Engine: Level 1 and Level 2 instantiation for Batch C models',
      (tester) async {
        // Level 1: Default preset instantiation
        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine(
              model: AppBarModel.editorialTypography,
              body: const Center(
                child: Text('Editorial Level 1 Body'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(EditorialTypographyHeaderWidget), findsOneWidget);
        expect(find.text('Editorial Level 1 Body'), findsOneWidget);

        // Level 2: Strongly-typed custom configuration
        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine.custom(
              model: AppBarModel.cardDeckStacked,
              configuration: const CardDeckStackedConfig(
                deckTitle: 'Custom Level 2 Deck',
                cards: [
                  DeckCardItem(title: 'Custom Platinum'),
                ],
              ),
              body: const Center(
                child: Text('Card Deck Body C'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Custom Level 2 Deck'), findsOneWidget);
        expect(find.text('Custom Platinum'), findsOneWidget);
        expect(find.text('Card Deck Body C'), findsOneWidget);
      },
    );

    testWidgets(
      'Zero-Leak Model Switching: Dynamically switches between Models 9, 10, 11, and 12 with complete resource isolation',
      (tester) async {
        final controller = AppBarController(initialModel: AppBarModel.editorialTypography);

        await tester.pumpWidget(
          MaterialApp(
            home: AppBarEngine(
              controller: controller,
              model: AppBarModel.editorialTypography,
              body: Container(height: 1200.0),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(controller.currentModel, equals(AppBarModel.editorialTypography));
        expect(find.byType(EditorialTypographyHeaderWidget), findsOneWidget);

        // Switch to Model 10: cardDeckStacked
        controller.changeModel(AppBarModel.cardDeckStacked);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.cardDeckStacked));
        expect(find.byType(EditorialTypographyHeaderWidget), findsNothing);
        expect(find.byType(CardDeckStackedHeaderWidget), findsOneWidget);

        // Switch to Model 11: minimalistMicroBar
        controller.changeModel(AppBarModel.minimalistMicroBar);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.minimalistMicroBar));
        expect(find.byType(CardDeckStackedHeaderWidget), findsNothing);
        expect(find.byType(MinimalistMicroBarHeaderWidget), findsOneWidget);

        // Switch to Model 12: profileIdentity
        controller.changeModel(AppBarModel.profileIdentity);
        await tester.pumpAndSettle();

        expect(controller.currentModel, equals(AppBarModel.profileIdentity));
        expect(find.byType(MinimalistMicroBarHeaderWidget), findsNothing);
        expect(find.byType(ProfileIdentityHeaderWidget), findsOneWidget);
      },
    );

    testWidgets(
      'Batch C: Accessibility reduced motion fallbacks render cleanly without layout exceptions',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(disableAnimations: true),
                  child: Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        const EditorialTypographyHeaderWidget(
                          config: EditorialTypographyConfig(
                            headline: 'Accessible Editorial',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                        const CardDeckStackedHeaderWidget(
                          config: CardDeckStackedConfig(
                            deckTitle: 'Accessible Deck',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                        const MinimalistMicroBarHeaderWidget(
                          config: MinimalistMicroBarConfig(
                            pathBreadcrumb: 'accessible / micro / bar',
                            expandedHeight: 48.0,
                            collapsedHeight: 38.0,
                          ),
                        ),
                        const ProfileIdentityHeaderWidget(
                          config: ProfileIdentityConfig(
                            userName: 'Accessible Profile',
                            expandedHeight: 90.0,
                            collapsedHeight: 44.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Accessible Editorial'), findsWidgets);
        expect(find.text('Accessible Deck'), findsWidgets);
        expect(find.text('accessible / micro / bar'), findsWidgets);
        expect(find.text('Accessible Profile'), findsWidgets);

        // Scroll across all slivers under reduced motion
        await tester.drag(find.byType(CustomScrollView), const Offset(0.0, -300.0));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  });
}
