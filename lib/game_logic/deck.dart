import 'dart:math';
import '../models/card_model.dart';

class Deck {
  List<CardModel> cards = [];

  Deck({
    required int playerCount,
    int thingCount = 1,
    int flamethrowerCount = 5,
    int analysisCount = 1,
    int axeCount = 1,
    int quarantineCount = 6,
    int barricadedDoorCount = 1,
    int suspicionCount = 1,
    int changeTurnCount = 10,
    int panicCount = 5,
    int persistenceCount = 2,
    int whiskeyCount = 1,
    int swapPlacesCount = 2,
    int lookAroundCount = 2,
    int temptationCount = 2,
    int reelInCount = 1,
    int fineHereCount = 1,
    int fearCount = 1,
    int noBarbecueCount = 1,
    int missCount = 1,
    int noThanksCount = 1,
    int hplovecraftCount = 1,
    int necronomiconCount = 1,
    int chainReactionCount = 2,
    int forgetfulnessCount = 2,
    int getOutCount = 2,
    int badPartyCount = 1,
    int oneTwoCount = 1,
    int threeFourCount = 1,
    int confessionsCount = 1,
    int justBetweenUsCount = 1,
    int oopsCount = 1,
    int blindDateCount = 1,
    int letsBeFriendsCount = 1,
    int oldRopesCount = 1,
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
      persistenceCount: persistenceCount,
      whiskeyCount: whiskeyCount,
      swapPlacesCount: swapPlacesCount,
      lookAroundCount: lookAroundCount,
      temptationCount: temptationCount,
      reelInCount: reelInCount,
      fineHereCount: fineHereCount,
      fearCount: fearCount,
      noBarbecueCount: noBarbecueCount,
      missCount: missCount,
      noThanksCount: noThanksCount,
      hplovecraftCount: hplovecraftCount,
      necronomiconCount: necronomiconCount,
      chainReactionCount: chainReactionCount,
      forgetfulnessCount: forgetfulnessCount,
      getOutCount: getOutCount,
      badPartyCount: badPartyCount,
      oneTwoCount: oneTwoCount,
      threeFourCount: threeFourCount,
      confessionsCount: confessionsCount,
      justBetweenUsCount: justBetweenUsCount,
      oopsCount: oopsCount,
      blindDateCount: blindDateCount,
      letsBeFriendsCount: letsBeFriendsCount,
      oldRopesCount: oldRopesCount,
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
        required int persistenceCount,
        required int whiskeyCount,
        required int swapPlacesCount,
        required int lookAroundCount,
        required int temptationCount,
        required int reelInCount,
        required int fineHereCount,
        required int fearCount,
        required int noBarbecueCount,
        required int missCount,
        required int noThanksCount,
        required int hplovecraftCount,
        required int necronomiconCount,
        required int chainReactionCount,
        required int forgetfulnessCount,
        required int getOutCount,
        required int badPartyCount,
        required int oneTwoCount,
        required int threeFourCount,
        required int confessionsCount,
        required int justBetweenUsCount,
        required int oopsCount,
        required int blindDateCount,
        required int letsBeFriendsCount,
        required int oldRopesCount,
      }) {
    // Инфекционные карты
    int infectionCount = (playerCount / 2).ceil();
    for (int i = 0; i < infectionCount; i++) {
      cards.add(CardModel(
        name: "Заражение!",
        type: CardType.Infection,
        effect: "Получив эту карту от другого игрока, Вы становитесь зараженным",
      ));
    }

    // Карты событий
    _addCards("Нечто", CardType.Infection, "Главный по заражениям", thingCount);
    _addCards("Огнемёт", CardType.Event, "Соседний игрок выбывает из игры", flamethrowerCount);
    _addCards("Анализ", CardType.Event, "Посмотрите карты на руке соседнего игрока", analysisCount);
    _addCards("Топор", CardType.Event, "Сбросьте сыгранную карту 'Карантин' или 'Заколоченная дверь'", axeCount);
    _addCards("Карантин", CardType.Event, "Блокирует обмен и действия на 3 хода", quarantineCount);
    _addCards("Заколоченная дверь", CardType.Event, "Блокирует действия между игроками", barricadedDoorCount);
    _addCards("Подозрение", CardType.Event, "Посмотрите 1 случайную карту соседнего игрока", suspicionCount);
    _addCards("Упорство", CardType.Event, "Возьмите 3 карты, оставьте 1, сбросьте 2", persistenceCount);
    _addCards("Виски", CardType.Event, "Покажите все свои карты остальным", whiskeyCount);
    _addCards("Меняемся местами", CardType.Event, "Поменяйтесь местами с соседом", swapPlacesCount);
    _addCards("Гляди по сторонам", CardType.Event, "Очерёдность хода меняется", lookAroundCount);
    _addCards("Соблазн", CardType.Event, "Поменяйтесь 1 картой с любым игроком", temptationCount);
    _addCards("Сматывай удочки", CardType.Event, "Поменяйтесь местами с любым игроком", reelInCount);
    _addCards("Мне и здесь неплохо", CardType.Event, "Отмена смены места + взять карту", fineHereCount);
    _addCards("Страх", CardType.Event, "Отказ от обмена + взять карту", fearCount);
    _addCards("Никакого шашлыка", CardType.Event, "Отмена 'Огнемёта' + взять карту", noBarbecueCount);
    _addCards("Мимо", CardType.Event, "Перенаправление обмена + взять карту", missCount);
    _addCards("Нет уж, спасибо!", CardType.Event, "Отказ от обмена + взять карту", noThanksCount);
    _addCards("Г.Ф.Лавкрафт", CardType.Event, "Посмотрите карты любого игрока", hplovecraftCount);
    _addCards("Некрономикон", CardType.Event, "Любой игрок выбывает из игры", necronomiconCount);

    // Карты паники
    _addCards("Смена хода", CardType.Panic, "Меняет направление хода", changeTurnCount);
    _addCards("Паника!", CardType.Panic, "Сбрасывает карту", panicCount);
    _addCards("Цепная реакция", CardType.Panic, "Все передают 1 карту следующему", chainReactionCount);
    _addCards("Забывчивость", CardType.Panic, "Сбросьте 3, возьмите 3 новые", forgetfulnessCount);
    _addCards("Убирайся прочь!", CardType.Panic, "Поменяйтесь местами с любым", getOutCount);
    _addCards("И это вы называете вечеринкой?", CardType.Panic, "Сброс барьеров + смена мест", badPartyCount);
    _addCards("Раз, два...", CardType.Panic, "Поменяйтесь с 3-им игроком", oneTwoCount);
    _addCards("...три, четыре...", CardType.Panic, "Сброс 'Заколоченных дверей'", threeFourCount);
    _addCards("Время признаний", CardType.Panic, "Игроки показывают карты", confessionsCount);
    _addCards("Только между нами", CardType.Panic, "Покажите карты соседу", justBetweenUsCount);
    _addCards("Уупс!", CardType.Panic, "Покажите все свои карты", oopsCount);
    _addCards("Свидание вслепую", CardType.Panic, "Обмен с колодой", blindDateCount);
    _addCards("Давай дружить?", CardType.Panic, "Обмен с любым игроком", letsBeFriendsCount);
    _addCards("Старые верёвки", CardType.Panic, "Сброс всех 'Карантинов'", oldRopesCount);
  }

  void _addCards(String name, CardType type, String effect, int count) {
    for (int i = 0; i < count; i++) {
      cards.add(CardModel(name: name, type: type, effect: effect));
    }
  }

  void shuffle() => cards.shuffle(Random());
  CardModel? drawCard() => cards.isEmpty ? null : cards.removeLast();
  void addCard(CardModel card) => cards.add(card);
}