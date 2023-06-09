// import 'dart:html';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:mvvm_blackjack/models/data_layer.dart';
import 'package:playing_cards/playing_cards.dart';

// ----------------------------------------------------------------------------

class GameViewModel with ChangeNotifier {
  late Game _game;
  bool _houseHasChecked = false;
  bool _playerHasStayed = false;

  GameViewModel(Game game) {
    _game = game;
  }

  // ----------------------------------------------------------------------------

  List<PlayingCard> get houseCards => _game.houseCards;
  List<PlayingCard> get playerCards => _game.playerCards;
  bool get houseHasChecked => _houseHasChecked;
  bool get playerHasStayed => _playerHasStayed;
  GameResult get result => _game.result;

  // ----------------------------------------------------------------------------

  newGame() {
    const int constNumInitialCards = 2;

    _game.reset();
    _houseHasChecked = false;
    _playerHasStayed = false;

    for (int i = 0; i < constNumInitialCards; i++) {
      _game.houseDrawCard();
      _game.playerDrawCard();
    }

    notifyListeners();
  }

  // ----------------------------------------------------------------------------

  houseHit() {
    _game.houseDrawCard();

    notifyListeners();
  }

  // ----------------------------------------------------------------------------

  houseCheck(bool countOnePlayerAceAs11) {
    _houseHasChecked = true;
    _game.checkResult(countOnePlayerAceAs11:countOnePlayerAceAs11);

    notifyListeners();
  }

  // ----------------------------------------------------------------------------

  bool houseHasAce() {
    return _game.houseHasAce();
  }

  // ----------------------------------------------------------------------------

  playerHit() {
    _game.playerDrawCard();

    notifyListeners();
  }

  // ----------------------------------------------------------------------------

  playerStay({countOnePlayerAceAs11=false}) {
    _playerHasStayed = true;

    notifyListeners();
  }

  // ----------------------------------------------------------------------------

  bool playerHasAce() {
    return _game.playerHasAce();
  }

  // ----------------------------------------------------------------------------

  int cardsValue(List<PlayingCard> cards, {countOneAceAs11=false}) {
    return _game.cardsValue(cards, countOneAceAs11:countOneAceAs11);
  }
}