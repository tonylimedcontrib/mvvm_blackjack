import 'package:playing_cards/playing_cards.dart';
import 'data_layer.dart';

// ----------------------------------------------------------------------------

const int constBlackjackMaxValue = 21;

enum GameResult {
  none,
  draw,
  houseWin,
  playerWin
}

// ----------------------------------------------------------------------------

class Game {
  final Deck _deck = Deck();
  final List<PlayingCard> _houseCards = <PlayingCard>[];
  final List<PlayingCard> _playerCards = <PlayingCard>[];
  bool _houseChecked = false;
  bool _playerStayed = false;
  GameResult _result = GameResult.none;

  // ----------------------------------------------------------------------------

  List<PlayingCard> get houseCards => _houseCards;
  List<PlayingCard> get playerCards => _playerCards;
  bool get houseHasChecked => _houseChecked;
  bool get playerHasStayed => _playerStayed;
  GameResult get result => _result;

  // ----------------------------------------------------------------------------

  reset() {
    _readyForNextGame();
  }

  // ----------------------------------------------------------------------------

  houseCheck() {
    _houseChecked = true;
  }

  // ----------------------------------------------------------------------------

  playerStay() {
    _playerStayed = true;
  }

  // ----------------------------------------------------------------------------

  houseDrawCard() {
    if (_deck.isEmpty()) {
      return;
    }

    _houseCards.add(_deck.dealCard());
  }

  // ----------------------------------------------------------------------------

  playerDrawCard() {
    if (_deck.isEmpty()) {
      return;
    }

    _playerCards.add(_deck.dealCard());
  }

  // ----------------------------------------------------------------------------

  bool houseHasAce() {
    return _acePresent(_houseCards);
  }

  // ----------------------------------------------------------------------------

  bool playerHasAce() {
    return _acePresent(_playerCards);
  }

  // ----------------------------------------------------------------------------

  GameResult checkResult({countOneHouseAceAs11=false, countOnePlayerAceAs11=false}) {
    int houseCardsIntValue = cardsValue(_houseCards, countOneAceAs11:countOneHouseAceAs11);
    int playerCardsIntValue = cardsValue(_playerCards, countOneAceAs11:countOnePlayerAceAs11);

    if (houseCardsIntValue > constBlackjackMaxValue) {
      if (playerCardsIntValue > constBlackjackMaxValue) {
        // Both exceed max result.
        _result = GameResult.draw;
      }
      else {
        // Player is valid.
        _result = GameResult.playerWin;
      }
    }
    else {
      // House is valid.
      if (playerCardsIntValue > constBlackjackMaxValue) {
        // Player exceeds max result.
        _result = GameResult.houseWin;
      }
      else {
        // Both house & player are valid.
        if (houseCardsIntValue > playerCardsIntValue) {
          _result = GameResult.houseWin;
        }
        else if (houseCardsIntValue < playerCardsIntValue) {
          _result = GameResult.playerWin;
        }
        else {
          _result = GameResult.draw;
        }
      }
    }

    return _result;
  }

  // ----------------------------------------------------------------------------

  int cardsValue(List<PlayingCard> cards, {countOneAceAs11=false}) {
    const int constMaxAceValue = 11;

    int value = _cardsIntValue(cards);

    if (_acePresent(cards)) {
      // Minus 1 to account for the ace's value already calculated.
      value += (countOneAceAs11 ? (constMaxAceValue - 1): 0);
    }

    return value;
  }

  // ----------------------------------------------------------------------------

  _readyForNextGame() {
    _deck.initialize();
    _houseCards.clear();
    _playerCards.clear();
    _houseChecked = false;
    _playerStayed = false;
  }

  // ----------------------------------------------------------------------------

  bool _acePresent(List<PlayingCard> cards) {
    for (PlayingCard card in cards) {
      if (card.value == CardValue.ace) {
        return true;
      }
    }

    return false;
  }

  // ----------------------------------------------------------------------------

  int _cardsIntValue(List<PlayingCard> cards) {
    int totalValue = 0;

    for (PlayingCard card in cards) {
      totalValue += _oneCardIntValue(card);
    }

    return totalValue;
  }

  // ----------------------------------------------------------------------------

  int _oneCardIntValue(PlayingCard card) {
    const Map<CardValue, int> cardValueMap = {
      CardValue.two: 2,
      CardValue.three: 3,
      CardValue.four: 4,
      CardValue.five: 5,
      CardValue.six: 6,
      CardValue.seven: 7,
      CardValue.eight: 8,
      CardValue.nine: 9,
      CardValue.ten: 10,
      CardValue.jack: 10,
      CardValue.queen: 10,
      CardValue.king: 10,
      // Count ace as 1 to avoid an automatic "bust" in case of having 2 aces or more.
      // Player will be asked to count one of the aces they have as 1 or 11.
      CardValue.ace: 1,
      CardValue.joker_1: 0,
      CardValue.joker_2: 0,
    };

    return cardValueMap[card.value]!;
  }
}