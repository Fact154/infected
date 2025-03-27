import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../game_logic/game_manager.dart';
import '../../models/player_model.dart';
import '../../models/card_model.dart';

class LocalStorage {
  static const String _gameKey = 'game_state';

  Future<void> saveGame(GameManager game) async {
    final prefs = await SharedPreferences.getInstance();
    final gameState = {
      'players': game.players.map((p) => p.toJson()).toList(),
      'deck': game.deck.cards.map((c) => c.toJson()).toList(),
      'currentPlayerIndex': game.currentPlayerIndex,
      'isClockwise': game.isClockwise,
    };
    await prefs.setString(_gameKey, jsonEncode(gameState));
  }

  Future<GameManager?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final gameString = prefs.getString(_gameKey);
    if (gameString == null) return null;

    final gameState = jsonDecode(gameString) as Map<String, dynamic>;
    final players = (gameState['players'] as List).map((p) => PlayerModel.fromJson(p)).toList();
    final deckCards = (gameState['deck'] as List).map((c) => CardModel.fromJson(c)).toList();

    final game = GameManager(players.length);
    game.players = players;
    game.deck.cards = deckCards;
    game.currentPlayerIndex = gameState['currentPlayerIndex'];
    game.isClockwise = gameState['isClockwise'];
    return game;
  }
}