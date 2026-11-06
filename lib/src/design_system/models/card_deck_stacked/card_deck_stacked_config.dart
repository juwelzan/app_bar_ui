import 'package:flutter/material.dart';
import '../../app_bar_model_configuration.dart';
import 'deck_card_item.dart';

/// Strongly-typed configuration for Model 10: Card Deck Stacked Navigation.
///
/// Features physical stacked cards with z-depth shadows. At rest, overlapping cards
/// fan out downwards. On scroll, bottom cards slide and tuck sequentially under
/// the top active card, snapping into a sleek single consolidated card toolbar.
class CardDeckStackedConfig extends AppBarModelConfiguration {
  /// Creates a [CardDeckStackedConfig].
  const CardDeckStackedConfig({
    this.cards = const [
      DeckCardItem(
        title: 'Primary Visa Infinite',
        subtitle: '•••• 8920 • Exp 09/28',
        icon: Icons.credit_card,
        badge: 'Default',
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      DeckCardItem(
        title: 'Corporate Travel Card',
        subtitle: '•••• 4102 • Exp 11/27',
        icon: Icons.flight_takeoff,
        badge: 'Business',
        backgroundColor: Color(0xFF0F766E),
        foregroundColor: Colors.white,
      ),
      DeckCardItem(
        title: 'High-Yield Reserve',
        subtitle: '4.85% APY • Active',
        icon: Icons.savings_outlined,
        badge: 'Savings',
        backgroundColor: Color(0xFF4338CA),
        foregroundColor: Colors.white,
      ),
    ],
    this.activeCardIndex = 0,
    this.onCardSwiped,
    this.deckTitle = 'Card Wallet',
    this.cardElevation = 4.0,
    this.cardBorderRadius = 16.0,
    this.expandedHeight = 210.0,
    this.collapsedHeight = 60.0,
    this.cardOverlap = 18.0,
    super.safeArea = true,
    super.backgroundColor,
    super.surfaceTint,
    super.physics,
    super.elevation = 2.0,
  });

  /// Ordered stack of cards in the deck.
  final List<DeckCardItem> cards;

  /// Currently active top card index.
  final int activeCardIndex;

  /// Callback when a card is selected.
  final ValueChanged<int>? onCardSwiped;

  /// Header title for the deck container.
  final String deckTitle;

  /// Elevation shadow for individual deck cards.
  final double cardElevation;

  /// Corner radius of individual deck cards.
  final double cardBorderRadius;

  /// Total expanded height.
  final double expandedHeight;

  /// Collapsed height of the pinned consolidated toolbar.
  final double collapsedHeight;

  /// Vertical step overlap between adjacent cards in the resting fan.
  final double cardOverlap;
}
