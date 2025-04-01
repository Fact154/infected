import 'package:flutter/material.dart';
import '../../game_logic/game_manager.dart';
import '../../game_logic/exchange_manager.dart';
import '../widgets/player_card.dart';
import '../widgets/enlarged_card.dart';
import '../widgets/player_cards_dialog.dart';
import '../../models/player_model.dart';
import '../../models/card_model.dart';

class GameScreen extends StatefulWidget {
  final bool alien;
  final int playerCount;
  const GameScreen({
    Key? key,
    required this.playerCount,
    required this.alien,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager game;
  late ExchangeManager exchangeManager;
  String? enlargedCardName;
  String? selectedCardName;

  @override
  void initState() {
    super.initState();
    game = GameManager(widget.playerCount, widget.alien);
    exchangeManager = ExchangeManager(game: game, context: context);
  }

  void _handleCardTap(String cardName) {
    setState(() {
      if (exchangeManager.isExchangeMode) {
        // В режиме обмена
        exchangeManager.selectCardForExchange(cardName);
      } else {
        // В обычном режиме
        if (selectedCardName == cardName) {
          selectedCardName = null;
        } else {
          selectedCardName = cardName;
        }
      }
    });
  }

  void _handleCardLongPress(String cardName) {
    setState(() {
      enlargedCardName = cardName;
    });
  }

  void _showPlayerCards(PlayerModel player) {
    showDialog(
      context: context,
      builder: (context) => PlayerCardsDialog(player: player),
    );
  }

  void _handleCardAction(String action) {
    if (selectedCardName == null) return;

    setState(() {
      if (action == 'discard') {
        var card = game.getCurrentPlayer().hand.firstWhere((c) => c.name == selectedCardName);
        game.getCurrentPlayer().hand.remove(card);
        game.deck.cards.add(card);
        game.deck.shuffle();
      } else if (action == 'play') {
        print('Игрок пытается сыграть карту: $selectedCardName');
      } else if (action == 'exchange') {
        exchangeManager.startExchange(selectedCardName!);
      }
      selectedCardName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Игра")),
      body: Stack(
        children: [
          Column(
            children: [
              Text(
                "Текущий игрок: ${game.getCurrentPlayer().name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: game.players.length,
                  itemBuilder: (context, index) {
                    var player = game.players[index];
                    return GestureDetector(
                      onTap: () => _showPlayerCards(player),
                      child: ListTile(
                        title: Text(player.name),
                        subtitle: Text(
                          "Карт: ${player.hand.length}, ${player.isAlive ? 'жив' : 'мёртв'}, ${player.isQuarantined ? 'в карантине' : ''}, ${player.isBarricaded ? 'за баррикадой' : ''}",
                        ),
                        leading: Icon(
                          player.role == Role.Thing ? Icons.bug_report : 
                          player.role == Role.Infected ? Icons.coronavirus : 
                          Icons.person,
                          color: player.role == Role.Thing ? Colors.red :
                                 player.role == Role.Infected ? Colors.green :
                                 Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 180),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        game.drawAndProcessCard(game.getCurrentPlayer());
                      });
                    },
                    child: const Text("Взять карту"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCardName = null;
                        exchangeManager.resetExchange();
                        game.nextTurn();
                      });
                    },
                    child: const Text("Следующий ход"),
                  ),
                ],
              ),
            ],
          ),
          if (enlargedCardName != null)
            Positioned.fill(
              child: EnlargedCard(
                cardName: enlargedCardName!,
                onDismiss: () => setState(() => enlargedCardName = null),
                imageVariant: game.getCurrentPlayer().hand
                    .firstWhere((card) => card.name == enlargedCardName)
                    .imageVariant,
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: enlargedCardName != null ? 20 : 60,
            child: Column(
              children: [
                if (selectedCardName != null && !exchangeManager.isExchangeMode)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (game.getCurrentPlayer().hand.length == 4) ...[
                          ElevatedButton(
                            onPressed: () => _handleCardAction('exchange'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Обменять"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _handleCardAction('play'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Сыграть"),
                          ),
                        ],
                        if (game.getCurrentPlayer().hand.length >= 5) ...[
                          ElevatedButton(
                            onPressed: () => _handleCardAction('discard'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Сбросить"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _handleCardAction('play'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Сыграть"),
                          ),
                        ],
                      ],
                    ),
                  ),
                if (exchangeManager.isExchangeMode && exchangeManager.selectedCardName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              exchangeManager.completeExchange();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Обменять"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _handleCardAction('play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Сыграть"),
                        ),
                      ],
                    ),
                  ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: enlargedCardName != null ? 0.0 : 1.0,
                  child: const Text(
                    "Ваши карты:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (game.getCurrentPlayer().hand.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (var card in game.getCurrentPlayer().hand)
                          Container(
                            width: enlargedCardName != null ? 72 : 80,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              card.name,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: enlargedCardName != null ? 108 : 120,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: game.getCurrentPlayer().hand.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var card in game.getCurrentPlayer().hand)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (enlargedCardName != null) {
                                        setState(() {
                                          enlargedCardName = card.name;
                                          selectedCardName = card.name;
                                        });
                                      } else {
                                        _handleCardTap(card.name);
                                      }
                                    },
                                    onLongPress: () {
                                      if (enlargedCardName == null) {
                                        _handleCardLongPress(card.name);
                                        setState(() {
                                          selectedCardName = card.name;
                                        });
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedCardName == card.name ? Colors.blue : Colors.transparent,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: PlayerCard(
                                        cardName: card.name,
                                        cardType: card.type,
                                        width: enlargedCardName != null ? 72 : 80,
                                        height: enlargedCardName != null ? 108 : 120,
                                        imageVariant: card.imageVariant,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            "У вас нет карт",
                            style: TextStyle(
                              backgroundColor: Colors.white70,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}