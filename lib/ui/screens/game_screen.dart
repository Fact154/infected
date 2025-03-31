import 'package:flutter/material.dart';
import '../../game_logic/game_manager.dart';
import '../widgets/player_card.dart'; // Импорт виджета PlayerCard

class GameScreen extends StatefulWidget {
  final bool alien;
  final int playerCount;
  const GameScreen({
    Key? key,
    required this.playerCount,
    required this.alien, // Добавлен alien в конструктор
  }) : super(key: key);
  //const GameScreen({required this.playerCount, Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager game;

  @override
  void initState() {
    super.initState();
    game = GameManager(widget.playerCount, widget.alien);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Игра")),
      body: Column(
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
          // Отображение карт текущего игрока
          const Text(
            "Ваши карты:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120, // Высота для отображения карт
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: game.getCurrentPlayer().hand.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal, // Горизонтальная прокрутка
                    itemCount: game.getCurrentPlayer().hand.length,
                    itemBuilder: (context, index) {
                      var card = game.getCurrentPlayer().hand[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: PlayerCard(cardName: card.name),
                      );
                    },
                  )
                : const Text("У вас нет карт"),
          ),
          const SizedBox(height: 20),
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
                  });
                },
                child: const Text("Следующий ход"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}