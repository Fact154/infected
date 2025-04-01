import 'dart:math';
import '../models/player_model.dart';
import '../models/card_model.dart';
import '../models/card_type.dart';
import 'deck.dart';
import 'game_start.dart';


class GameManager {
  List<PlayerModel> players = [];
  Deck deck;
  int currentPlayerIndex = 0;
  bool isClockwise = true;

  GameManager(int playerCount, bool alien) : deck = Deck(playerCount: playerCount) {
    // Создаем игроков
    for (int i = 1; i <= playerCount; i++) {
      players.add(PlayerModel(name: "Игрок $i", role: Role.Human));
    }

    // Используем GameSetup для настройки игры
    GameStart(
      players: players,
      deck: deck,
      playerCount: playerCount,
      alien_card: alien,
    ).setup();
  }

  PlayerModel getCurrentPlayer() => players[currentPlayerIndex];

  void nextTurn() {
    currentPlayerIndex = _getNextPlayerIndex();
    while (!players[currentPlayerIndex].isAlive) {
      currentPlayerIndex = _getNextPlayerIndex();
    }
  }

  void forceNextTurn() {
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
    print("\n=== Попытка обмена картами ===");
    print("Инициатор: ${initiator.name}");
    print("Цель: ${target.name}");
    print("Карта инициатора: ${initiatorCard.name}");
    print("Карта цели: ${targetCard.name}");

    // Проверка на карту "Нечто"
    if (initiatorCard.name == "Нечто" || targetCard.name == "Нечто") {
      print("❌ Обмен невозможен! Карту 'Нечто' нельзя обменять");
      return;
    }

    // Проверка на карту "Заражение!"
    if (initiatorCard.name == "Заражение!") {
      // Проверяем, является ли инициатор Нечто или зараженным
      if (initiator.role != Role.Thing && initiator.role != Role.Infected) {
        print("❌ Обмен невозможен! Только Нечто или зараженный игрок может передать карту 'Заражение!'");
        return;
      }
      
      // Если инициатор заражен, проверяем, является ли цель Нечто
      if (initiator.role == Role.Infected && target.role != Role.Thing) {
        print("❌ Обмен невозможен! Зараженный игрок может передать карту 'Заражение!' только Нечто");
        return;
      }
    }

    if (!initiator.isAlive || !target.isAlive || initiator.isQuarantined || target.isQuarantined || initiator.isBarricaded || target.isBarricaded) {
      print("❌ Обмен невозможен! Проверьте состояние игроков");
      return;
    }
    if (!initiator.hand.contains(initiatorCard) || !target.hand.contains(targetCard)) {
      print("❌ Обмен невозможен! У игроков нет указанных карт");
      return;
    }

    if (initiatorCard.name == "Заражение!" && target.role == Role.Infected) {
      int targetInfections = target.hand.where((c) => c.name == "Заражение!").length;
      if (targetInfections >= 3) {
        print("❌ Обмен невозможен! У цели уже максимум карт 'Заражение!'");
        return;
      }
    }

    initiator.hand.remove(initiatorCard);
    target.hand.remove(targetCard);
    initiator.hand.add(targetCard);
    target.hand.add(initiatorCard);
    
    print("✅ Обмен выполнен успешно");
    print("=== Конец обмена ===\n");
  }
}
