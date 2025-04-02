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
        "Цепная реакция",
        "Забывчивость",
        "Убирайся прочь!",
        "И это вы называете вечеринкой?",
        "Раз, два...",
        "...три, четыре...",
        "Время признаний",
        "Только между нами",
        "Уупс!",
        "Свидание вслепую",
        "Давай дружить?",
        "Старые верёвки"
    ];
    if (alien_card == false) {
      excludedCards.add("Нечто"); // Добавляем карту "Нечто", если alien == false
    }

    // Удаляем карты паники из колоды перед раздачей
    List<CardModel> panicCards = deck.cards.where((card) => excludedCards.contains(card.name)).toList();
    deck.cards.removeWhere((card) => excludedCards.contains(card.name));

    // Перемешиваем колоду
    deck.shuffle();

    // Раздаем каждому игроку по 4 карты
    for (var player in players) {
      int cardsToDraw = player.role == Role.Thing ? 3 : 4; // Ограничиваем количество карт для "Нечто"

      for (int j = 0; j < cardsToDraw; j++) {
        CardModel? card = deck.drawCard(); // Берем карту из колоды
        if (card == null) {
          throw Exception("Колода пуста! Невозможно раздать карты.");
        }

        player.addCard(card); // Выдаем карту игроку
        print("${player.name} получил карту: ${card.name}"); // Отладочный вывод
      }
    }


    // Выдаем дополнительную карту первому игроку, если у него меньше 5 карт
    if (players[0].hand.length == 4) {
      CardModel? card;
      do {
        card = deck.drawCard();
        if (card == null) {
          throw Exception("Колода пуста! Невозможно выдать дополнительную карту.");
        }
      } while (excludedCards.contains(card.name));

      players[0].addCard(card);
      print("${players[0].name} получил дополнительную карту: ${card.name}");
    }
        // Добавляем карты паники обратно в колоду и перемешиваем
    deck.cards.addAll(panicCards);
    deck.shuffle();

  }
}