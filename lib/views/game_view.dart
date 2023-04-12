import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:mvvm_blackjack/viewmodels/game_viewmodel.dart';
import 'package:mvvm_blackjack/models/data_layer.dart';
import 'package:mvvm_blackjack/views/game_house_peek_view.dart';

// ----------------------------------------------------------------------------

const double _constCardBorderRadius = 8.0;
const double _constCardBorderWidth = 1.0;
const double _constCardViewHeight = 150.0;
const double _constCardViewWidth = 150.0;
const double _constSectionElevation = 1.0;
const double _constSectionSpacing = 8.0;
const _constDisabledHandler = null;

const String _constGameTitle = 'MVVM Blackjack';
const FontWeight _constGameTitleFontWeight = FontWeight.w300;
const double _constGameTitleFontSize = 28.0;
const double _constGameResultFontSize = 20.0;

const String _constGameHouse = 'HOUSE';
const String _constGamePlayer = 'PLAYER';
const String _constGameMsgDraw = "It's a draw.";
const String _constGameMsgHouseWins = 'House wins!';
const String _constGameMsgPlayerWins = 'Player wins!';
const String _constGameMsgValue = 'Value';

const String _constGameButtonTextNewGame = 'New Game';
const String _constGameButtonTextHit = 'Hit';
const String _constGameButtonTextCheck = 'Check';
const String _constGameButtonTextStay = 'Stay';
const String _constGameCheckboxTextAce = 'Ace as 11';

const Color _constGameTitleColor = Colors.black;
const Color _constCheckButtonColor = Colors.greenAccent;
const Color _constStayButtonColor = Colors.redAccent;

const Color _constResultTextColor = Colors.redAccent;
const Color _constResultTextEndColor = Colors.lightBlueAccent;

// ----------------------------------------------------------------------------

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

// ----------------------------------------------------------------------------

class _GameViewState extends State<GameView> {
  late GameViewModel _viewModel;
  bool _countPlayerAceAs11 = false;
  bool _peekViewVisible = false;

  // ----------------------------------------------------------------------------

  @override
  void initState() {
    _viewModel = Provider.of<GameViewModel>(context, listen: false);

    super.initState();
  }

  // ----------------------------------------------------------------------------

  _buildCardsSection(String title,
      List<PlayingCard> cards,
      List<Widget> actionList,
      {
        onlyFirstCardDown=true,
        isPlayer=false,
        countPlayerAceAs11=false,
      }) {

    Widget cardValueWidget = const SizedBox();
    List<PlayingCardView> cardViewList = [];
    Widget cardViewListWidget;

    ShapeBorder cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_constCardBorderRadius),
      side: const BorderSide(color: Colors.black12, width: _constCardBorderWidth)
    );

    if (cards.length > 1) {
      for (int i = 0; i < cards.length; i++) {
        cardViewList.add(
          PlayingCardView(
            card: cards[i],
            showBack: (onlyFirstCardDown ? (i == 0) : false),
            shape: cardShape
          )
        );
      }

      cardViewListWidget = FlatCardFan(
        children: cardViewList,
      );
    }
    else if (cards.length == 1) {
      cardViewListWidget = PlayingCardView(
        card: cards[0],
        showBack: onlyFirstCardDown,
        shape: cardShape
      );
    }
    else {
      cardViewListWidget = const SizedBox();
    }

    if (isPlayer) {
      cardValueWidget = Text("$_constGameMsgValue: ${_viewModel.cardsValue(cards, countOneAceAs11: countPlayerAceAs11)}");
    }
    else {
      if (_viewModel.houseHasChecked) {
        cardValueWidget = Text("$_constGameMsgValue: ${_viewModel.cardsValue(cards, countOneAceAs11: _viewModel.houseHasAce())}");
      }
    }

    return Padding(
      padding: const EdgeInsets.all(_constSectionSpacing),
      child: Card(
        elevation: _constSectionElevation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2*_constSectionSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              const SizedBox(height: _constSectionSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: _constCardViewHeight,
                    width: _constCardViewWidth,
                    child: cardViewListWidget,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: actionList,
                  )
                ],
              ),
              const SizedBox(height: _constSectionSpacing),
              cardValueWidget,
            ],
          )
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------

  _onHouseHitButtonPressed() {
    _viewModel.houseHit();
  }

  // ----------------------------------------------------------------------------

  _onHouseCheckButtonPressed() {
    _viewModel.houseCheck(_countPlayerAceAs11);
  }

  // ----------------------------------------------------------------------------

  _onPeekLongPressHandler() {
    setState(() {
      _peekViewVisible = true;
    });
  }

  // ----------------------------------------------------------------------------

  _onPeekLongPressEndHandler(LongPressEndDetails? _) {
    setState(() {
      _peekViewVisible = false;
    });
  }

  // ----------------------------------------------------------------------------

  _buildHouseSection() {
    // After House has checked, no action is possible.
    bool canPlay = (
      (_viewModel.houseHasChecked == false) &&
      _viewModel.houseCards.isNotEmpty
    );

    Widget peekViewWidget;
    Widget peekViewRowWidget;

    if (_peekViewVisible) {
      peekViewWidget = const SizedBox(
        height: _constCardViewHeight,
        width: _constCardViewWidth,
        child: GameHousePeekView(),
      );
    }
    else {
      peekViewWidget = const SizedBox();
    }

    if (canPlay) {
      peekViewRowWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          peekViewWidget,
          Padding(
            padding: const EdgeInsets.all(_constSectionSpacing),
            child: GestureDetector(
              onLongPress: _onPeekLongPressHandler,
              onLongPressEnd: _onPeekLongPressEndHandler,
              child: const Icon(Icons.remove_red_eye),
            ),
          ),
        ],
      );
    }
    else {
      peekViewRowWidget = const SizedBox();
    }

    List<Widget> actionList = [
      ElevatedButton(
        onPressed: (canPlay ? _onHouseHitButtonPressed : _constDisabledHandler),
        child: const Text(_constGameButtonTextHit),
      ),
      ElevatedButton(
        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(_constCheckButtonColor)),
        onPressed: (canPlay ? _onHouseCheckButtonPressed : _constDisabledHandler),
        child: const Text(_constGameButtonTextCheck),
      ),
      const SizedBox(height: _constSectionSpacing),
      peekViewRowWidget,
    ];

    return _buildCardsSection(_constGameHouse,
        _viewModel.houseCards,
        actionList,
        onlyFirstCardDown: (_viewModel.houseHasChecked == false)
    );
  }

  // ----------------------------------------------------------------------------

  _onPlayerHitButtonPressed() {
    _viewModel.playerHit();
  }

  // ----------------------------------------------------------------------------

  _onPlayerStayButtonPressed() {
    _viewModel.playerStay();
  }

  // ----------------------------------------------------------------------------

  _onPlayAceAs11CheckboxChanged(bool? newValue) {
    setState(() {
      _countPlayerAceAs11 = newValue!;
    });
  }

  // ----------------------------------------------------------------------------

  _buildPlayerSection() {
    bool canPlay = (
      (_viewModel.playerHasStayed == false) &&
      _viewModel.playerCards.isNotEmpty &&
      (_viewModel.houseHasChecked == false)
    );

    List<Widget> actionList = [
      ElevatedButton(
        onPressed: (canPlay ? _onPlayerHitButtonPressed : _constDisabledHandler),
        child: const Text(_constGameButtonTextHit),
      ),
      ElevatedButton(
        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(_constStayButtonColor)),
        onPressed: (canPlay ? _onPlayerStayButtonPressed : _constDisabledHandler),
        child: const Text(_constGameButtonTextStay),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _viewModel.playerHasAce() && _countPlayerAceAs11,
            onChanged: ((canPlay && _viewModel.playerHasAce()) ? _onPlayAceAs11CheckboxChanged : _constDisabledHandler)
          ),
          // SizedBox(width: _constSectionSpacing),
          const Text(_constGameCheckboxTextAce),
        ],
      )
    ];

    return _buildCardsSection(_constGamePlayer,
      _viewModel.playerCards,
      actionList,
      onlyFirstCardDown: false,
      isPlayer: true,
      countPlayerAceAs11: _countPlayerAceAs11
    );
  }

  // ----------------------------------------------------------------------------

  _onNewGameButtonPress() {
    _countPlayerAceAs11 = false;
    _viewModel.newGame();
  }

  // ----------------------------------------------------------------------------

  _buildGameButtons() {
    return Padding(
      padding: const EdgeInsets.all(_constSectionSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _onNewGameButtonPress,
            child: const Text(_constGameButtonTextNewGame),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(_constSectionSpacing),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: _constGameTitle,
              style: TextStyle(
                fontWeight: _constGameTitleFontWeight,
                fontSize: _constGameTitleFontSize,
                color: _constGameTitleColor,
              ),
            )
          ]
        )
      ),
    );
  }

  // ----------------------------------------------------------------------------

  String _resultToString() {
    String text = '---';

    switch (_viewModel.result) {
      case GameResult.draw:
        text = _constGameMsgDraw;
        break;

      case GameResult.houseWin:
        text = _constGameMsgHouseWins;
        break;

      case GameResult.playerWin:
        text = _constGameMsgPlayerWins;
            break;

      default:
        break;
    }

    return text;
  }

  // ----------------------------------------------------------------------------

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.all(_constSectionSpacing),
      child: BlinkText(
        _resultToString(),
        style: const TextStyle(fontSize: _constGameResultFontSize, color: _constResultTextColor),
        endColor: _constResultTextEndColor,
      ),
    );
  }

  // ----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (_, providedViewModel, __) {
        _viewModel = providedViewModel;

        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTitle(),
                _buildResult(),
                _buildHouseSection(),
                _buildPlayerSection(),
                _buildGameButtons(),
              ],
            ),
          ),
        );
      }
    );
  }
}
