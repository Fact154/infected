import 'package:flutter/material.dart';
import '../../game_logic/game_manager.dart';
import '../widgets/player_card.dart'; // Импорт виджета PlayerCard
import '../widgets/enlarged_card.dart';

class GameScreen extends StatefulWidget {
  final int playerCount;
  const GameScreen({required this.playerCount, Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager game;
  String? enlargedCardName;
  String? selectedCardName;

  @override
  void initState() {
    super.initState();
    game = GameManager(widget.playerCount);
  }

  void _handleCardTap(String cardName) {
    setState(() {
      if (selectedCardName == cardName) {
        selectedCardName = null;
      } else {
        selectedCardName = cardName;
      }
    });
  }

  void _handleCardLongPress(String cardName) {
    setState(() {
      enlargedCardName = cardName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Игра")),
      body: Stack(
        children: [
          // Основной контент (список игроков и кнопки)
          Column(
            children: [
              Text(
                "Текущий игрок: ${game.getCurrentPlayer().name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Отображение списка игроков
              Expanded(
                child: ListView.builder(
                  itemCount: game.players.length,
                  itemBuilder: (context, index) {
                    var player = game.players[index];
                    return ListTile(
                      title: Text(player.name),
                      subtitle: Text(
                          "Карт: ${player.hand.length}, ${player.isAlive ? 'жив' : 'мёртв'}"),
                    );
                  },
                ),
              ),
              const SizedBox(height: 180), // Место для карт
              // Кнопки управления
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
                        game.nextTurn();
                        selectedCardName = null;
                      });
                    },
                    child: const Text("Следующий ход"),
                  ),
                ],
              ),
            ],
          ),
          // Увеличенная карта (средний слой)
          if (enlargedCardName != null)
            Positioned.fill(
              child: EnlargedCard(
                cardName: enlargedCardName!,
                onDismiss: () => setState(() => enlargedCardName = null),
              ),
            ),
          // Карты на руке (верхний слой)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: enlargedCardName != null ? 20 : 60,
            child: Column(
              children: [
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
                // Добавляем контейнер для названий карт
                if (game.getCurrentPlayer().hand.isNotEmpty)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: game.getCurrentPlayer().hand.length,
                      itemBuilder: (context, index) {
                        var card = game.getCurrentPlayer().hand[index];
                        return Container(
                          width: enlargedCardName != null ? 72 : 80,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
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
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 4),
                // Контейнер с картами
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: enlargedCardName != null ? 108 : 120,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: game.getCurrentPlayer().hand.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.getCurrentPlayer().hand.length,
                          itemBuilder: (context, index) {
                            var card = game.getCurrentPlayer().hand[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GestureDetector(
                                onTap: () {
                                  if (enlargedCardName != null) {
                                    // Если есть увеличенная карта, показываем новую и выбираем её
                                    setState(() {
                                      enlargedCardName = card.name;
                                      selectedCardName = card.name;
                                    });
                                  } else {
                                    // Если нет увеличенной карты, обрабатываем как выбор
                                    _handleCardTap(card.name);
                                  }
                                },
                                onLongPress: () {
                                  if (enlargedCardName == null) {
                                    // Показываем увеличенную карту только если её ещё нет
                                    _handleCardLongPress(card.name);
                                    // Также выбираем карту при увеличении
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
                                  ),
                                ),
                              ),
                            );
                          },
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