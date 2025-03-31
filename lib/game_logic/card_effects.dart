// card_effects.dart
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'game_manager.dart';
import 'dart:math';

class CardEffects {
  static void applyEffect(CardModel card, PlayerModel player, {PlayerModel? target, GameManager? gameManager}) {
    switch (card.name) {
    // Уже реализованные карты (оставляем их без изменений)
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

    // Новые карты
      case "Упорство":
        if (gameManager != null) {
          // Берем 3 карты
          List<CardModel> drawnCards = [];
          for (int i = 0; i < 3; i++) {
            var newCard = gameManager.deck.drawCard();
            if (newCard != null) {
              drawnCards.add(newCard);
            }
          }

          // Оставляем одну карту на руке
          if (drawnCards.isNotEmpty) {
            player.addCard(drawnCards.first); // Добавляем первую карту на руку
            drawnCards.removeAt(0); // Убираем её из временного списка
          }

          // Сбрасываем остальные карты
          for (var cardToDiscard in drawnCards) {
            gameManager.deck.discardCard(cardToDiscard);
          }

          // Игрок должен сыграть или сбросить одну карту
          if (player.hand.isNotEmpty) {
            var cardToPlayOrDiscard = player.hand.last; // Пример: выбираем последнюю карту
            player.hand.remove(cardToPlayOrDiscard);
            gameManager.deck.discardCard(cardToPlayOrDiscard); // Сбрасываем её
          }
        }
        break;

      case "Виски":
      // Показываем все карты игрока
        print("${player.name} показывает свои карты: ${player.hand}");
        break;

      case "Меняемся местами":
        if (target != null && !target.isQuarantined && !target.isBarricaded) {
          if (gameManager != null) {
            // Меняем местами игрока и цель
            int playerIndex = gameManager.players.indexOf(player);
            int targetIndex = gameManager.players.indexOf(target);
            gameManager.players[playerIndex] = target;
            gameManager.players[targetIndex] = player;
          }
        } else {
          print("Обмен местами невозможен!");
        }
        break;

      case "Соблазн":
        if (target != null && !target.isQuarantined) {
          // Обмениваемся одной картой
          if (player.hand.isNotEmpty && target.hand.isNotEmpty) {
            CardModel playerCard = player.hand.last;
            CardModel targetCard = target.hand.last;

            player.hand.remove(playerCard);
            target.hand.remove(targetCard);

            player.addCard(targetCard);
            target.addCard(playerCard);
          }
        } else {
          print("Обмен картами невозможен!");
        }
        break;

      case "Сматывай удочки":
        if (target != null && !target.isQuarantined) {
          if (gameManager != null) {
            // Меняем местами игрока и цель, игнорируя заколоченные двери
            int playerIndex = gameManager.players.indexOf(player);
            int targetIndex = gameManager.players.indexOf(target);
            gameManager.players[playerIndex] = target;
            gameManager.players[targetIndex] = player;
          }
        } else {
          print("Обмен местами невозможен!");
        }
        break;

      case "Мне и здесь неплохо":
        if (gameManager != null) {
          // Отменяем эффект карт "Меняемся местами" или "Сматывай удочки"
          print("${player.name} отменяет эффект карты обмена местами.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;

      case "Страх":
        if (gameManager != null) {
          // Отказываемся от обмена картами
          print("${player.name} отказывается от обмена картами.");
          if (target != null && target.hand.isNotEmpty) {
            CardModel refusedCard = target.hand.last;
            print("${player.name} видит карту, от которой отказался: ${refusedCard.name}");
          }
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;

      case "Никакого шашлыка":
        if (gameManager != null) {
          // Отменяем эффект карты "Огнемёт"
          print("${player.name} отменяет эффект карты 'Огнемёт'.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;

      case "Мимо":
        if (gameManager != null) {
          // Отказываемся от обмена картами
          print("${player.name} отказывается от обмена картами.");
          // Вместо игрока картами меняется следующий игрок
          int nextPlayerIndex = gameManager._getNextPlayerIndex();
          PlayerModel nextPlayer = gameManager.players[nextPlayerIndex];
          if (nextPlayer.hand.isNotEmpty && player.hand.isNotEmpty) {
            CardModel playerCard = player.hand.last;
            CardModel nextPlayerCard = nextPlayer.hand.last;

            player.hand.remove(playerCard);
            nextPlayer.hand.remove(nextPlayerCard);

            player.addCard(nextPlayerCard);
            nextPlayer.addCard(playerCard);

            print("${nextPlayer.name} меняется картами вместо ${player.name}.");
          }
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;

      case "Нет уж, спасибо!":
        if (gameManager != null) {
          // Отказываемся от обмена картами
          print("${player.name} отказывается от обмена картами.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;

      case "Г.Ф.Лавкрафт":
        if (target != null) {
          // Смотрим карты выбранного игрока
          print("${player.name} смотрит карты игрока ${target.name}: ${target.hand}");
        }
        break;

      case "Некрономикон":
        if (target != null) {
          // Выбираем игрока, который выбывает из игры
          print("${player.name} использует 'Некрономикон' на ${target.name}.");
          target.isAlive = false;
        }
        break;


//TODO: НИЖЕ БУДУТ Идти карты паники. Нужно разделить и гровые карты и карты паники в разные файлы.
      case "Меняет направление":
        gameManager.isClockwise = !gameManager.isClockwise;
        break;
      case "Сбрасывает карту":
        var currentPlayer = gameManager.getCurrentPlayer();
        if (currentPlayer.hand.isNotEmpty) {
          currentPlayer.hand.removeLast();
        }
        break;

    // Новые карты паники
      case "Цепная реакция":
        for (int i = 0; i < gameManager.players.length; i++) {
          PlayerModel currentPlayer = gameManager.players[i];
          PlayerModel nextPlayer = gameManager.players[(i + 1) % gameManager.players.length];

          // Игрок передает одну карту следующему игроку
          if (currentPlayer.hand.isNotEmpty) {
            CardModel cardToPass = currentPlayer.hand.removeLast();
            nextPlayer.addCard(cardToPass);

            // Проверка заражения
            if (cardToPass.name == "Заражение!" && nextPlayer.role == Role.Human) {
              nextPlayer.role = Role.Infected;
            }
          }
        }
        break;

      case "Забывчивость":
        var currentPlayer = gameManager.getCurrentPlayer();

        // Сбрасываем 3 карты с руки
        for (int i = 0; i < 3; i++) {
          if (currentPlayer.hand.isNotEmpty) {
            CardModel discardedCard = currentPlayer.hand.removeLast();
            gameManager.deck.discardCard(discardedCard);
          }
        }

        // Берем 3 новые карты событий
        for (int i = 0; i < 3; i++) {
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            currentPlayer.addCard(newCard);
          }
        }
        break;

      case "Убирайся прочь!":
        var currentPlayer = gameManager.getCurrentPlayer();
        PlayerModel? target = _selectTarget(gameManager, currentPlayer);

        // Меняем местами с выбранным игроком, если он не на карантине
        if (target != null && !target.isQuarantined) {
          int playerIndex = gameManager.players.indexOf(currentPlayer);
          int targetIndex = gameManager.players.indexOf(target);
          gameManager.players[playerIndex] = target;
          gameManager.players[targetIndex] = currentPlayer;
        } else {
          print("Обмен местами невозможен!");
        }
        break;

      case "И это вы называете вечеринкой?":
      // Сбрасываем все карты "Карантин" и "Заколоченная дверь"
        for (var player in gameManager.players) {
          player.isQuarantined = false;
          player.isBarricaded = false;
        }

        // Меняем местами игроков попарно
        for (int i = 0; i < gameManager.players.length; i += 2) {
          if (i + 1 < gameManager.players.length) {
            PlayerModel player1 = gameManager.players[i];
            PlayerModel player2 = gameManager.players[i + 1];
            int index1 = gameManager.players.indexOf(player1);
            int index2 = gameManager.players.indexOf(player2);
            gameManager.players[index1] = player2;
            gameManager.players[index2] = player1;
          }
        }
        break;

      case "Раз, два...":
        var currentPlayer = gameManager.getCurrentPlayer();
        PlayerModel? target = _selectTarget(gameManager, currentPlayer, offset: 3);

        // Меняемся местами с третьим игроком слева/справа, если он не на карантине
        if (target != null && !target.isQuarantined) {
          int playerIndex = gameManager.players.indexOf(currentPlayer);
          int targetIndex = gameManager.players.indexOf(target);
          gameManager.players[playerIndex] = target;
          gameManager.players[targetIndex] = currentPlayer;
        } else {
          print("Обмен местами невозможен!");
        }
        break;

      case "..три, четыре..":
      // Сбрасываем все карты "Заколоченная дверь"
        for (var player in gameManager.players) {
          player.isBarricaded = false;
        }
        break;

      case "Время признаний":
        for (var player in gameManager.players) {
          bool hasInfection = player.hand.any((c) => c.name == "Заражение!");
          if (hasInfection) {
            print("${player.name} показывает карту 'Заражение!'");
            break; // Время признаний заканчивается
          } else {
            print("${player.name} показывает свои карты: ${player.hand}");
          }
        }
        break;

      case "Только между нами":
        var currentPlayer = gameManager.getCurrentPlayer();
        PlayerModel? target = _selectTarget(gameManager, currentPlayer);

        if (target != null) {
          print("${target.name} видит карты игрока ${currentPlayer.name}: ${currentPlayer.hand}");
        } else {
          print("Цель не выбрана!");
        }
        break;

      case "Уупс!":
        var currentPlayer = gameManager.getCurrentPlayer();
        print("${currentPlayer.name} показывает свои карты: ${currentPlayer.hand}");
        break;

      case "Свидание вслепую":
        var currentPlayer = gameManager.getCurrentPlayer();

        if (currentPlayer.hand.isNotEmpty) {
          CardModel cardToSwap = currentPlayer.hand.removeLast(); // Убираем карту с руки
          var topCard = gameManager.deck.drawCard(); // Берем верхнюю карту колоды

          if (topCard != null) {
            currentPlayer.addCard(topCard); // Добавляем новую карту на руку
          }

          // Сбрасываем старую карту
          gameManager.deck.discardCard(cardToSwap);
        }
        break;

      case "Давай дружить?":
        var currentPlayer = gameManager.getCurrentPlayer();
        PlayerModel? target = _selectTarget(gameManager, currentPlayer);

        if (target != null && !target.isQuarantined) {
          if (currentPlayer.hand.isNotEmpty && target.hand.isNotEmpty) {
            CardModel playerCard = currentPlayer.hand.last;
            CardModel targetCard = target.hand.last;

            currentPlayer.hand.remove(playerCard);
            target.hand.remove(targetCard);

            currentPlayer.addCard(targetCard);
            target.addCard(playerCard);

            print("${currentPlayer.name} и ${target.name} обменялись картами.");
          } else {
            print("Обмен карт невозможен!");
          }
        } else {
          print("Цель находится на карантине или не выбрана!");
        }
        break;

      case "Старые верёвки":
        for (var player in gameManager.players) {
          player.isQuarantined = false; // Сбрасываем все эффекты карантина
        }
        print("Все эффекты 'Карантин' сброшены.");
        break;
    }
  }

  // Вспомогательный метод для выбора цели
  static PlayerModel? _selectTarget(GameManager gameManager, PlayerModel currentPlayer, {int offset = 1}) {
    int currentIndex = gameManager.players.indexOf(currentPlayer);
    int targetIndex = (currentIndex + offset) % gameManager.players.length;
    return gameManager.players[targetIndex];
  }

}