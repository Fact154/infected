// card_effects.dart
import '../models/card_model.dart';
import '../models/player_model.dart';
import '../models/card_type.dart';
import 'event_cards.dart';
import 'panic_cards.dart';
import 'game_manager.dart';

class CardEffects {
  static void applyEffect(CardModel card, PlayerModel player, {PlayerModel? target, GameManager? gameManager}) {
    if (gameManager == null) return;

    if (card.type == CardType.Event) {
      EventCards.applyEffect(card, player, target: target, gameManager: gameManager);
    } else if (card.type == CardType.Panic) {
      PanicCards.applyEffect(card, player, gameManager);
    }
  }
}