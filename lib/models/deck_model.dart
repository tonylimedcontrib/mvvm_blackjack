import 'dart:math';
import 'package:playing_cards/playing_cards.dart';

// ----------------------------------------------------------------------------

class Deck {
  List<PlayingCard> _deck = <PlayingCard>[];

  // ----------------------------------------------------------------------------

  Deck() {
    initialize();
  }

  // ----------------------------------------------------------------------------

  initialize() {
    _deck = standardFiftyTwoCardDeck();
    _deck.shuffle();
  }

  // ----------------------------------------------------------------------------

  bool isEmpty() {
    return _deck.isEmpty;
  }

  // ----------------------------------------------------------------------------

  dealCard() {
    if (isEmpty()) {
      return null;
    }

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    int nextCardIndex = random.nextInt(_deck.length);

    PlayingCard card = _deck[nextCardIndex];

    _deck.removeAt(nextCardIndex);

    return card;
  }
}
