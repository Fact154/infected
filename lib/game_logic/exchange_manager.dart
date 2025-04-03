import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/card_model.dart';
import 'game_manager.dart';

class ExchangeManager {
  final GameManager game;
  final BuildContext context;
  
  PlayerModel? exchangeInitiator;
  CardModel? exchangeInitiatorCard;
  String? cardForExchange;
  String? selectedCardName;
  bool isExchangeMode = false;

  ExchangeManager({
    required this.game,
    required this.context,
  });

  void startExchange(String selectedCardName) {
    if (selectedCardName.isEmpty) return;
    
    // Находим следующего живого игрока
    final currentPlayerIndex = game.players.indexOf(game.getCurrentPlayer());
    var nextPlayerIndex = (currentPlayerIndex + 1) % game.players.length;
    
    // Ищем следующего живого игрока
    while (!game.players[nextPlayerIndex].isAlive) {
      nextPlayerIndex = (nextPlayerIndex + 1) % game.players.length;
      
      // Если мы прошли весь круг и вернулись к текущему игроку
      if (nextPlayerIndex == currentPlayerIndex) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Нет живых игроков для обмена'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Проверка на карту "Заражение!"
    if (selectedCardName == "Заражение!") {
      final currentPlayer = game.getCurrentPlayer();
      // Проверяем, является ли инициатор Нечто или зараженным
      if (currentPlayer.role != Role.Thing && currentPlayer.role != Role.Infected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Обмен невозможен! Только Нечто или зараженный игрок может передать карту "Заражение!"'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Если инициатор заражен, проверяем, является ли цель Нечто
      if (currentPlayer.role == Role.Infected && game.players[nextPlayerIndex].role != Role.Thing) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Обмен невозможен! Зараженный игрок может передать карту "Заражение!" только Нечто'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Проверяем количество карт заражения у цели
      final targetPlayer = game.players[nextPlayerIndex];
      if (targetPlayer.role == Role.Infected) {
        int targetInfections = targetPlayer.hand.where((c) => c.name == "Заражение!").length;
        if (targetInfections >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Обмен невозможен! У цели уже максимум карт "Заражение!"'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }
    
    // Сохраняем информацию об обмене
    exchangeInitiator = game.getCurrentPlayer();
    exchangeInitiatorCard = exchangeInitiator!.hand.firstWhere(
      (card) => card.name == selectedCardName,
    );
    
    // Переходим к следующему живому игроку
    while (game.getCurrentPlayer() != game.players[nextPlayerIndex]) {
      game.forceNextTurn();
    }
    
    cardForExchange = selectedCardName;
    isExchangeMode = true;
  }

  void selectCardForExchange(String cardName) {
    selectedCardName = cardName;
  }

  void completeExchange() {
    if (exchangeInitiator == null || 
        exchangeInitiatorCard == null || 
        selectedCardName == null) return;

    final currentPlayer = game.getCurrentPlayer();
    
    // Проверяем, является ли текущий игрок ближайшим к инициатору обмена
    final initiatorIndex = game.players.indexOf(exchangeInitiator!);
    final currentPlayerIndex = game.players.indexOf(currentPlayer);
    final nextPlayerIndex = (initiatorIndex + 1) % game.players.length;
    
    if (currentPlayerIndex != nextPlayerIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Можно обменяться картами только с ближайшим игроком'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentPlayerCard = currentPlayer.hand.firstWhere(
      (card) => card.name == selectedCardName,
    );

    game.exchangeCards(
      exchangeInitiator!,
      currentPlayer,
      exchangeInitiatorCard!,
      currentPlayerCard,
    );
    
    // Сбрасываем все состояния обмена
    exchangeInitiator = null;
    exchangeInitiatorCard = null;
    cardForExchange = null;
    selectedCardName = null;
    isExchangeMode = false;
  }

  void resetExchange() {
    exchangeInitiator = null;
    exchangeInitiatorCard = null;
    cardForExchange = null;
    selectedCardName = null;
    isExchangeMode = false;
  }
} 