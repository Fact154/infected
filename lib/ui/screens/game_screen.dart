import 'package:flutter/material.dart';
import '../../game_logic/game_manager.dart';
import '../widgets/player_card.dart';
import '../widgets/enlarged_card.dart';
import 'dart:math';
import '../../models/player_model.dart';// Import для генерации случайных чисел

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
  String? enlargedCardName;
  String? selectedCardName;

  @override
  void initState() {
    super.initState();
    game = GameManager(widget.playerCount, widget.alien);
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

  // --- Добавлено ---
  Widget _buildPlayerWidget(PlayerModel player, double x, double y) {
    return Positioned(
      left: x,
      top: y,
      child: PlayerInfoWidget(player: player), // Используем новый виджет
    );
  }
  // --- Добавлено ---
  @override
  Widget build(BuildContext context) {
    final double tableWidth = MediaQuery.of(context).size.width * 0.8; // Ширина стола (80% от ширины экрана)
    final double tableHeight = MediaQuery.of(context).size.height * 0.6; // Высота стола (60% от высоты экрана)
    final double centerX = MediaQuery.of(context).size.width / 2;
    final double centerY = MediaQuery.of(context).size.height / 2;
    final double radius = min(tableWidth, tableHeight) / 2 * 0.8; // Радиус круга (80% от меньшей стороны стола)
    List<Offset> playerPositions = [];

    // Рассчитываем позиции игроков
    for (int i = 0; i < game.players.length; i++) {
      double angle = (2 * pi / game.players.length) * i - pi / 2; // Распределение по кругу
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      playerPositions.add(Offset(x, y));
    }


    return Scaffold(
      appBar: AppBar(title: const Text("Игра"), backgroundColor: Colors.green,),
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: tableWidth,
              height: tableHeight,
              decoration: BoxDecoration(
                color: Colors.brown, // Коричневый стол
                borderRadius: BorderRadius.circular(tableWidth / 10), // Заглугленные углы
              ),
            ),
          ),
          // Основной контент (игроки, стол и кнопки)
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
                    // Здесь будет логика отрисовки стола (например, изображение)
                    //  Можно добавить изображение стола здесь, если нужно
                    // Пример:
                    // Center(
                    //   child: Image.asset('assets/table.png', width: tableWidth, height: tableHeight),
                    // ),

                    // Отображаем виджеты игроков
                    for (int i = 0; i < game.players.length; i++)
                      _buildPlayerWidget(
                        game.players[i],
                        playerPositions[i].dx - 25, // Центрирование по X (учитывая ширину виджета)
                        playerPositions[i].dy - 25, // Центрирование по Y (учитывая высоту виджета)
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Отступ между игроками и кнопками
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
                imageVariant: game.getCurrentPlayer().hand
                    .firstWhere((card) => card.name == enlargedCardName)
                    .imageVariant,
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