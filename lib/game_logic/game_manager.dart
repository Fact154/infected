import 'dart:math';
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'deck.dart';

  class GameManager {
    List<PlayerModel> players = [];
    Deck deck;
    int currentPlayerIndex = 0;
    bool isClockwise = true;

    GameManager(int playerCount) : deck = Deck(playerCount:playerCount) {
      // Создаем игроков
      for (int i = 1; i <= playerCount; i++) {
        players.add(PlayerModel(name: "Игрок $i", role: Role.Human));
      }

      setupGame(playerCount);
    }

    void setupGame(int playerCount) {
      // Назначаем одному игроку роль "Нечто"
      int thingIndex = Random().nextInt(playerCount);
      players[thingIndex].role = Role.Thing;

      // Находим карту "Нечто" в колоде и выдаем её игроку с ролью "Нечто"
      try {
        var thingCount = deck.cards.firstWhere((card) => card.name == "Нечто");
        players[thingIndex].addCard(thingCount); // Выдаем карту игроку
        deck.cards.remove(thingCount); // Удаляем карту из колоды
      } catch (e) {
        throw Exception("Колода не содержит карту 'Нечто'!");
      }

      // Перемешиваем колоду
      deck.shuffle();

      // Раздаем каждому игроку по 4 карты
      for (var player in players) {
        int cardsToDraw = player.role == Role.Thing ? 3 : 4; // Ограничиваем количество карт для "Нечто"
        for (int i = 0; i < cardsToDraw; i++) {
          var card = deck.drawCard();
          if (card != null) {         // Проверяем, что карта не null
            player.addCard(card);
            print("${player.name} получил карту: ${card.name}"); // Отладочный вывод
          } else {
            throw Exception("Колода пуста! Невозможно раздать карты.");
        }
      }
            // Перемешиваем колоду
      deck.shuffle();
    }
  }
  PlayerModel getCurrentPlayer() => players[currentPlayerIndex];

  void nextTurn() {
    currentPlayerIndex = _getNextPlayerIndex();
    while (!players[currentPlayerIndex].isAlive) {
      currentPlayerIndex = _getNextPlayerIndex();
    }
  }

  int _getNextPlayerIndex() {
    int step = isClockwise ? 1 : -1;
    return (currentPlayerIndex + step + players.length) % players.length;
  }

  void drawAndProcessCard(PlayerModel player) {
    var card = deck.drawCard();
    if (card == null) return;

    if (card.type == CardType.Panic) {
      _applyPanicEffect(card, player);
    } else {
      player.addCard(card);
      if (card.name == "Заражение!" && player.role == Role.Human) {
        player.role = Role.Infected;
      }
    }
  }

  void _applyPanicEffect(CardModel card, PlayerModel player) {
    switch (card.effect) {
      case "Меняет направление":
        isClockwise = !isClockwise;
        break;
      case "Сбрасывает карту":
        if (player.hand.isNotEmpty) {
          player.hand.removeLast();
        }
        break;
    }
  }

  void playCard(PlayerModel player, CardModel card, PlayerModel? target) {
    if (!player.hand.contains(card) || !player.isAlive || player.isQuarantined) return;

    switch (card.name) {
      case "Огнемёт":
        if (target != null && !target.isQuarantined) {
          target.isAlive = false;
        }
        break;
      case "Карантин":
        if (target != null) {
          target.isQuarantined = true;
        }
        break;
      case "Анализ":
        if (target != null) {
          print("${target.name} - ${target.role}");
        }
        break;
      case "Топор":
        if (target != null && target.isBarricaded) {
          target.isBarricaded = false;
        }
        break;
      case "Заколоченная дверь":
        if (target != null) {
          target.isBarricaded = true;
        }
        break;
      case "Подозрение":
        if (target != null && target.hand.isNotEmpty) {
          print("${target.hand[Random().nextInt(target.hand.length)]}");
        }
        break;
    }
    player.hand.remove(card);
  }

  bool checkGameEnd() {
    bool thingAlive = players.any((p) => p.role == Role.Thing && p.isAlive);
    bool humansAlive = players.any((p) => p.role == Role.Human && p.isAlive);
    if (!thingAlive) return true; // Люди победили
    if (!humansAlive) return true; // Нечто победило
    return false;
  }

  void printState() {
    for (var player in players) {
      print(player);
    }
    print("Текущий ход: ${getCurrentPlayer().name}, направление: ${isClockwise ? 'по часовой' : 'против'}");
  }
void exchangeCards(PlayerModel initiator, PlayerModel target, CardModel initiatorCard, CardModel targetCard) {
  if (!initiator.isAlive || !target.isAlive || initiator.isQuarantined || target.isQuarantined || initiator.isBarricaded || target.isBarricaded) {
    print("Обмен невозможен!");
    return;
  }
  if (!initiator.hand.contains(initiatorCard) || !target.hand.contains(targetCard)) return;

  if (initiatorCard.name == "Заражение!" && target.role == Role.Infected) {
    int targetInfections = target.hand.where((c) => c.name == "Заражение!").length;
    if (targetInfections >= 3) {
      print("У цели уже максимум карт 'Заражение!'");
      return;
    }
  }
  if (!initiator.hand.contains(initiatorCard) || !target.hand.contains(targetCard)) return;

  initiator.hand.remove(initiatorCard);
  target.hand.remove(targetCard);
  initiator.addCard(targetCard);
  target.addCard(initiatorCard);

  // Проверка заражения
  if (initiatorCard.name == "Заражение!" && target.role == Role.Human) {
    target.role = Role.Infected;
  }
  if (targetCard.name == "Заражение!" && initiator.role == Role.Human) {
    initiator.role = Role.Infected;
  }
}
}
