import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_blackjack/viewmodels/game_viewmodel.dart';
import 'package:playing_cards/playing_cards.dart';

// ----------------------------------------------------------------------------

const double _constCardBorderRadius = 8.0;
const double _constCardBorderWidth = 1.0;
const double _constCardViewHeight = 150.0*4/7;
const double _constCardViewWidth = 150.0*4/7;
const double _constSectionElevation = 1.0;
const double _constSectionSpacing = 8.0;

// ----------------------------------------------------------------------------

class GameHousePeekView extends StatefulWidget {
  const GameHousePeekView({Key? key}) : super(key: key);

  @override
  State<GameHousePeekView> createState() => _GameHousePeekViewState();
}

// ----------------------------------------------------------------------------

class _GameHousePeekViewState extends State<GameHousePeekView> {
  late GameViewModel _viewModel;

  // ----------------------------------------------------------------------------

  @override
  void initState() {
    _viewModel = Provider.of<GameViewModel>(context, listen: false);

    super.initState();
  }

  // ----------------------------------------------------------------------------

  _buildCardsSection(List<PlayingCard> cards) {

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
          shape: cardShape
      );
    }
    else {
      cardViewListWidget = const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(_constSectionSpacing/2),
      child: Card(
        elevation: _constSectionElevation,
        child: Padding(
            padding: const EdgeInsets.all(_constSectionSpacing/2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: _constCardViewHeight,
                      width: _constCardViewWidth,
                      child: cardViewListWidget,
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------

  _buildHouseSection() {
    return _buildCardsSection(_viewModel.houseCards);
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
                _buildHouseSection(),
              ],
            ),
          ),
        );
      }
    );
  }
}
