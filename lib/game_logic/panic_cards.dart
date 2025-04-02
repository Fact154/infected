// panic_cards.dart
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'game_manager.dart';

class PanicCards {
  static void applyEffect(CardModel card, PlayerModel player, GameManager gameManager) {
    switch (card.name) {
      case "Меняет направление":
        gameManager.isClockwise = !gameManager.isClockwise;
        break;
      case "Сбрасывает карту":
        var currentPlayer = gameManager.getCurrentPlayer();
        if (currentPlayer.hand.isNotEmpty) {
          currentPlayer.hand.removeLast();
        }
        break;
      case "Цепная реакция":
        for (int i = 0; i < gameManager.players.length; i++) {
          PlayerModel currentPlayer = gameManager.players[i];
          PlayerModel nextPlayer = gameManager.players[(i + 1) % gameManager.players.length];
          if (currentPlayer.hand.isNotEmpty) {
            CardModel cardToPass = currentPlayer.hand.removeLast();
            nextPlayer.addCard(cardToPass);
            if (cardToPass.name == "Заражение!" && nextPlayer.role == Role.Human) {
              nextPlayer.role = Role.Infected;
            }
          }
        }
        break;
      case "Забывчивость":
        var currentPlayer = gameManager.getCurrentPlayer();
        for (int i = 0; i < 3; i++) {
          if (currentPlayer.hand.isNotEmpty) {
            CardModel discardedCard = currentPlayer.hand.removeLast();
            gameManager.deck.discardCard(discardedCard);
          }
        }
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
        for (var player in gameManager.players) {
          player.isQuarantined = false;
          player.isBarricaded = false;
        }
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
        for (var player in gameManager.players) {
          player.isBarricaded = false;
        }
        break;
      case "Время признаний":
        for (var player in gameManager.players) {
          bool hasInfection = player.hand.any((c) => c.name == "Заражение!");
          if (hasInfection) {
            print("${player.name} показывает карту 'Заражение!'");
            break;
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
          CardModel cardToSwap = currentPlayer.hand.removeLast();
          var topCard = gameManager.deck.drawCard();
          if (topCard != null) {
            currentPlayer.addCard(topCard);
          }
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
          player.isQuarantined = false;
        }
        print("Все эффекты 'Карантин' сброшены.");
        break;
    }
  }

  static PlayerModel? _selectTarget(GameManager gameManager, PlayerModel currentPlayer, {int offset = 1}) {
    int currentIndex = gameManager.players.indexOf(currentPlayer);
    int targetIndex = (currentIndex + offset) % gameManager.players.length;
    return gameManager.players[targetIndex];
  }
}