// game_manager.dart
import 'dart:math';
import '../models/player_model.dart';
import '../models/card_model.dart';
import '../models/card_type.dart';
import 'deck.dart';
import 'card_effects.dart';

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
    _setupGame(alien);
  }

  void _setupGame(bool alien) {
    // Раздаем начальные карты
    for (var player in players) {
      for (int i = 0; i < 4; i++) {
        var card = deck.drawCard();
        if (card != null) {
          player.addCard(card);
        }
      }
    }

    // Если есть карта Нечто, назначаем её случайному игроку
    if (alien) {
      PlayerModel alienPlayer = players[Random().nextInt(players.length)];
      alienPlayer.role = Role.Thing;
    }
  }

  PlayerModel getCurrentPlayer() => players[currentPlayerIndex];

  void nextTurn() {
    currentPlayerIndex = getNextPlayerIndex();
    while (!players[currentPlayerIndex].isAlive) {
      currentPlayerIndex = getNextPlayerIndex();
    }
  }

  void forceNextTurn() {
    currentPlayerIndex = getNextPlayerIndex();
    while (!players[currentPlayerIndex].isAlive) {
      currentPlayerIndex = getNextPlayerIndex();
    }
  }

  int getNextPlayerIndex() {
    int step = isClockwise ? 1 : -1;
    return (currentPlayerIndex + step + players.length) % players.length;
  }

  void drawAndProcessCard(PlayerModel player) {
    var card = deck.drawCard();
    if (card == null) return;

    if (card.type == CardType.Panic) {
      CardEffects.applyEffect(card, player, gameManager: this);
    } else {
      player.addCard(card);
      if (card.name == "Заражение!" && player.role == Role.Human) {
        print("\n=== ИЗМЕНЕНИЕ СТАТУСА ИГРОКА ===");
        print("${player.name} получил карту Заражение!");
        print("Старая роль: ${player.role}");
        player.role = Role.Infected;
        print("Новая роль: ${player.role}");
        print("================================\n");
      }
    }
  }

  void playCard(PlayerModel player, CardModel card, PlayerModel? target) {
    if (!player.hand.contains(card) || !player.isAlive || player.isQuarantined) return;

    CardEffects.applyEffect(card, player, target: target, gameManager: this);
    player.hand.remove(card);
  }

  bool checkGameEnd() {
    bool thingAlive = players.any((p) => p.role == Role.Thing && p.isAlive);
    bool humansAlive = players.any((p) => p.role == Role.Human && p.isAlive);

    if (!thingAlive) {
      print("Люди победили!");
      return true;
    }
    if (!humansAlive) {
      print("Нечто победило!");
      return true;
    }
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

    if (!initiator.isAlive || !target.isAlive || initiator.isQuarantined || target.isQuarantined || initiator.isBarricaded || target.isBarricaded) {
      print("❌ Обмен невозможен! Проверьте состояние игроков");
      return;
    }
    if (!initiator.hand.contains(initiatorCard) || !target.hand.contains(targetCard)) {
      print("❌ Обмен невозможен! У игроков нет указанных карт");
      return;
    }

    initiator.hand.remove(initiatorCard);
    target.hand.remove(targetCard);
    initiator.hand.add(targetCard);
    target.hand.add(initiatorCard);
    
    print("✅ Обмен выполнен успешно");
    print("=== Конец обмена ===\n");
      // Проверка заражения
    if (initiatorCard.name == "Заражение!" && target.role == Role.Human) {
      target.role = Role.Infected;
    }
    if (targetCard.name == "Заражение!" && initiator.role == Role.Human) {
      initiator.role = Role.Infected;
    }
  }
}