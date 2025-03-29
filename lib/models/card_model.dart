import 'card_type.dart';

// lib/models/card_model.dart
import 'card_type.dart';

class CardModel {
  final String name;
  final CardType type;
  final String effect;

  CardModel({
    required this.name,
    required this.type,
    required this.effect,
  });

  // Добавляем методы для сериализации
  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.index, // Сохраняем индекс enum
    'effect': effect,
  };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    name: json['name'],
    type: CardType.values[json['type']], // Восстанавливаем enum
    effect: json['effect'],
  );
}