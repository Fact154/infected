import 'dart:math';
import '../models/card_model.dart';


class Deck {
  List<CardModel> cards = [];

  Deck(int playerCount) {
    _initializeDeck(playerCount);
    shuffle();
  }

  void _initializeDeck(int playerCount) {
    cards.add(CardModel(name: "Нечто", type: CardType.Event, effect: "Стартовая роль"));
    int infectionCount = (playerCount / 2).ceil();
    for (int i = 0; i < infectionCount; i++) {
      cards.add(CardModel(name: "Заражение!", type: CardType.Infection));
    }
    cards.addAll([
      CardModel(name: "Огнемёт", type: CardType.Event, effect: "Уничтожает игрока"),
      CardModel(name: "Анализ", type: CardType.Event, effect: "Показывает роль"),
      CardModel(name: "Топор", type: CardType.Event, effect: "Уничтожает баррикаду"),
      CardModel(name: "Карантин", type: CardType.Event, effect: "Блокирует обмен"),
      CardModel(name: "Заколоченная дверь", type: CardType.Event, effect: "Блокирует действия"),
      CardModel(name: "Подозрение", type: CardType.Event, effect: "Показывает случайную карту"),
      CardModel(name: "Смена хода", type: CardType.Panic, effect: "Меняет направление"),
      CardModel(name: "Паника!", type: CardType.Panic, effect: "Сбрасывает карту"),
    ]);
  }

  void shuffle() => cards.shuffle(Random());
  CardModel? drawCard() => cards.isEmpty ? null : cards.removeLast();
  void addCard(CardModel card) => cards.add(card);
}