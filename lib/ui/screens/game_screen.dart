import 'package:flutter/material.dart';
import '../../game_logic/game_manager.dart';
import '../widgets/player_card.dart';
import '../../game_logic/exchange_manager.dart';
import '../widgets/enlarged_card.dart';
import 'dart:math';
import '../../models/player_model.dart';// Import для генерации случайных чисел
import '../widgets/player_cards_dialog.dart';

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

  Widget _buildPlayerWidget(PlayerModel player, double x, double y, bool isCurrentPlayer) {
    bool canSeeRole = game.getCurrentPlayer().canSeePlayer(player);
    bool isCurrentPlayerThing = game.getCurrentPlayer().role == Role.Thing;

    // Добавляем отладочную информацию
    print("\n=== ОТОБРАЖЕНИЕ ИГРОКА ===");
    print("Текущий игрок: ${game.getCurrentPlayer().name} (${game.getCurrentPlayer().role})");
    print("Проверяемый игрок: ${player.name} (${player.role})");
    print("Может видеть роль: $canSeeRole");
    print("Текущий игрок - Нечто: $isCurrentPlayerThing");
    print("Роль текущего игрока: ${game.getCurrentPlayer().role}");
    print("==========================\n");

    return Positioned(
      left: x - 25,
      top: y - 25,
      child: GestureDetector(
        onTap: () => _showPlayerCards(player),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCurrentPlayer ? Colors.yellow : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrentPlayer ? Colors.red : Colors.transparent,
                  width: 2.0,
                )
              ),
              child: Center(
                child: canSeeRole
                    ? const Icon(Icons.bug_report, color: Colors.red, size: 30)
                    : (isCurrentPlayer || player == game.getCurrentPlayer()
                        ? Text(
                            player.name.substring(player.name.length - 1),
                            style: const TextStyle(fontSize: 16),
                          )
                        : Container()
                    ),
              ),
            ),
            // --- Отображение карт ---
            Row(
              children: List.generate(
                player.hand.length, // Отображаем количество карт
                    (index) => Padding(
                  padding: const EdgeInsets.only(left: 2.0), // Небольшой отступ между картами
                  child: Image.asset(
                    'assets/cards/Событие.png', // Путь к изображению рубашки карты
                    width: 15,   // Ширина карты
                    height: 20,  // Высота карты
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Добавлено ---
  Widget buildPlayerWidget(PlayerModel player, double x, double y) {
    return Positioned(
      left: x,
      top: y,
      child: PlayerInfoWidget(player: player), // Используем новый виджет
    );
  }
  // --- Добавлено ---
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height * 0.8;
    final double tableRadius = min(screenWidth, screenHeight) * 0.3;
    final double centerX = MediaQuery.of(context).size.width / 2;
    final double centerY = MediaQuery.of(context).size.height * 0.35;
    List<Offset> playerPositions = [];

    for (int i = 0; i < game.players.length; i++) {
      double angle = (2 * pi / game.players.length) * i - pi / 2;
      double x = centerX + tableRadius * cos(angle);
      double y = centerY + tableRadius * sin(angle);
      playerPositions.add(Offset(x, y));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Игра"), backgroundColor: Colors.green,),
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          // Устанавливаем фоновое изображение
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/game_desk.png"), // Путь к вашему фоновому изображению
                fit: BoxFit.cover, // Растягиваем изображение на весь экран
              ),
            ),
          ),
          // Добавляем полупрозрачный белый круг с градиентом
          Positioned(
            top: MediaQuery.of(context).size.height * 0.19, // Отступ сверху (20% от высоты экрана)
            left: MediaQuery.of(context).size.width / 2 - tableRadius*1.3, // Центрирование по горизонтали
            child: Container(
              width: tableRadius * 2.7, // Диаметр круга
              height: tableRadius * 2.7, // Диаметр круга
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Круглая форма
                gradient: RadialGradient(
                  colors: [
                    Colors.green.withOpacity(0.8), // Центр - полупрозрачный белый
                    Colors.green.withOpacity(0.01), // Края - почти прозрачный
                  ],
                  stops: [0.0, 1.0], // Определяет плавность перехода
                  radius: 1.0, // Радиус градиента
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                "Текущий игрок: ${game.getCurrentPlayer().name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // --- Изменено: Отображение игроков ---
              Expanded( // Чтобы Stack занял все доступное пространство
                child: Stack(
                  children: [
                    for (int i = 0; i < game.players.length; i++)
                      _buildPlayerWidget(
                        game.players[i],
                        playerPositions[i].dx,
                        playerPositions[i].dy - 25,
                        game.players[i] == game.getCurrentPlayer(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        game.drawAndProcessCard(game.getCurrentPlayer());
                      });
                    },
                    child: const Text("Взять карту"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
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
                                  // ... остальной код PlayerCard
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                      : const Center(child: Text("Нет карт на руке")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Добавлено ---
// Виджет для отображения информации об игроке
class PlayerInfoWidget extends StatelessWidget {
  final PlayerModel player;

  const PlayerInfoWidget({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, //  Ширина виджета
      height: 50, //  Высота виджета
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle, // Круглая форма
      ),
      child: Center(
        child: Text(
          player.name.substring(player.name.length-1), // Отображаем первую букву имени
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}