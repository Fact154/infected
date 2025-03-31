import 'dart:math';
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'deck.dart';

class GameStart {
  final List<PlayerModel> players;
  final Deck deck;
  final int playerCount;
  final bool alien_card;

  GameStart({
    required this.players,
    required this.deck,
    required this.playerCount,
    required this.alien_card,
  });

  void setup() {
    if (alien_card == true) {
    // Назначаем одному игроку роль "Нечто"
    int thingIndex = Random().nextInt(playerCount);
    players[thingIndex].role = Role.Thing;

    // Находим карту "Нечто" в колоде и выдаем её игроку с ролью "Нечто"
      try {
        var thingCard = deck.cards.firstWhere((card) => card.name == "Нечто");
        players[thingIndex].addCard(thingCard); // Выдаем карту игроку
        deck.cards.remove(thingCard); // Удаляем карту из колоды
      } catch (e) {
        throw Exception("Колода не содержит карту 'Нечто'!");
      }
    }

    // Список исключаемых карт
    final List<String> excludedCards = [
        "Паника!",
        "Смена хода",
        // Добавьте другие карты, которые нужно исключить
    ];
    if (alien_card == false) {
      excludedCards.add("Нечто"); // Добавляем карту "Нечто", если alien == false
    }


    // Перемешиваем колоду
    deck.shuffle();

    // Раздаем каждому игроку по 4 карты
    for (var player in players) {
      int cardsToDraw = player.role == Role.Thing ? 3 : 4; // Ограничиваем количество карт для "Нечто"

      for (int i = 0; i < cardsToDraw; i++) {
        CardModel? card;
        do {
          card = deck.drawCard(); // Берем карту из колоды
          if (card == null) {
            throw Exception("Колода пуста! Невозможно раздать карты.");
          }
        } while (excludedCards.contains(card.name)); // Проверяем, что карта не в списке исключений

        player.addCard(card); // Выдаем карту игроку
        print("${player.name} получил карту: ${card.name}"); // Отладочный вывод
      }
    }

    // Перемешиваем колоду после раздачи
    deck.shuffle();
  }
}