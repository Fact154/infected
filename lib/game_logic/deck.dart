import 'dart:math';
import '../models/card_model.dart';

class Deck {
  List<CardModel> cards = [];

  // Конструктор с дополнительными параметрами для количества карт
  Deck({
    required int playerCount,
    int thingCount = 1, // "Нечто"
    int flamethrowerCount = 5,
    int analysisCount = 1,
    int axeCount = 1,
    int quarantineCount = 6,
    int barricadedDoorCount = 1,
    int suspicionCount = 1,
    int changeTurnCount = 10,
    int panicCount = 5,
  }) {
    _initializeDeck(
      playerCount,
      thingCount: thingCount,
      flamethrowerCount: flamethrowerCount,
      analysisCount: analysisCount,
      axeCount: axeCount,
      quarantineCount: quarantineCount,
      barricadedDoorCount: barricadedDoorCount,
      suspicionCount: suspicionCount,
      changeTurnCount: changeTurnCount,
      panicCount: panicCount,
    );
    shuffle();
  }

  void _initializeDeck(
    int playerCount, {
    required int thingCount,
    required int flamethrowerCount,
    required int analysisCount,
    required int axeCount,
    required int quarantineCount,
    required int barricadedDoorCount,
    required int suspicionCount,
    required int changeTurnCount,
    required int panicCount,
  }) {
        // Добавляем карты "Заражение!"
    int infectionCount = (playerCount / 2).ceil();
    for (int i = 0; i < infectionCount; i++) {
      cards.add(CardModel(name: "Заражение!", type: CardType.Infection));
    }

    // Добавляем остальные карты с указанным количеством
    _addCards("Нечто", CardType.Event, "Главный по заражениям", thingCount);
    _addCards("Огнемёт", CardType.Event, "Уничтожает игрока", flamethrowerCount);
    _addCards("Анализ", CardType.Event, "Показывает роль", analysisCount);
    _addCards("Топор", CardType.Event, "Уничтожает баррикаду", axeCount);
    _addCards("Карантин", CardType.Event, "Блокирует обмен", quarantineCount);
    _addCards("Заколоченная дверь", CardType.Event, "Блокирует действия", barricadedDoorCount);
    _addCards("Подозрение", CardType.Event, "Показывает случайную карту", suspicionCount);
    _addCards("Смена хода", CardType.Panic, "Меняет направление", changeTurnCount);
    _addCards("Паника!", CardType.Panic, "Сбрасывает карту", panicCount);
  }

  // Вспомогательный метод для добавления карт
  void _addCards(String name, CardType type, String effect, int count) {
    for (int i = 0; i < count; i++) {
      cards.add(CardModel(name: name, type: type, effect: effect));
    }
  }

  void shuffle() => cards.shuffle(Random());
  CardModel? drawCard() => cards.isEmpty ? null : cards.removeLast();
  void addCard(CardModel card) => cards.add(card);
}