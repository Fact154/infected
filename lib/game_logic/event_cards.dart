// event_cards.dart
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'game_manager.dart';
import 'dart:math';

class EventCards {
  static void applyEffect(CardModel card, PlayerModel player, {PlayerModel? target, GameManager? gameManager}) {
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
      case "Упорство":
        if (gameManager != null) {
          List<CardModel> drawnCards = [];
          for (int i = 0; i < 3; i++) {
            var newCard = gameManager.deck.drawCard();
            if (newCard != null) {
              drawnCards.add(newCard);
            }
          }
          if (drawnCards.isNotEmpty) {
            player.addCard(drawnCards.first);
            drawnCards.removeAt(0);
          }
          for (var cardToDiscard in drawnCards) {
            gameManager.deck.discardCard(cardToDiscard);
          }
          if (player.hand.isNotEmpty) {
            var cardToPlayOrDiscard = player.hand.last;
            player.hand.remove(cardToPlayOrDiscard);
            gameManager.deck.discardCard(cardToPlayOrDiscard);
          }
        }
        break;
      case "Виски":
        print("${player.name} показывает свои карты: ${player.hand}");
        break;
      case "Меняемся местами":
        if (target != null && !target.isQuarantined && !target.isBarricaded) {
          if (gameManager != null) {
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
          print("${player.name} отменяет эффект карты обмена местами.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;
      case "Страх":
        if (gameManager != null) {
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
          print("${player.name} отменяет эффект карты 'Огнемёт'.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;
      case "Мимо":
        if (gameManager != null) {
          print("${player.name} отказывается от обмена картами.");
          int nextPlayerIndex = gameManager.getNextPlayerIndex();
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
          print("${player.name} отказывается от обмена картами.");
          var newCard = gameManager.deck.drawCard();
          if (newCard != null) {
            player.addCard(newCard);
          }
        }
        break;
      case "Г.Ф.Лавкрафт":
        if (target != null) {
          print("${player.name} смотрит карты игрока ${target.name}: ${target.hand}");
        }
        break;
      case "Некрономикон":
        if (target != null) {
          print("${player.name} использует 'Некрономикон' на ${target.name}.");
          target.isAlive = false;
        }
        break;
    }
  }
}