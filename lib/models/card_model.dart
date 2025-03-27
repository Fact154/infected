enum CardType { Event, Panic, Infection }

class CardModel {
  final String name;
  final CardType type;
  final String? effect; // Описание эффекта (например, "Уничтожает игрока")

  CardModel({required this.name, required this.type, this.effect});

  @override
  String toString() => '$name ($type)';
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.toString().split('.').last,
        'effect': effect,
      };

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        name: json['name'],
        type: CardType.values.firstWhere((t) => t.toString().split('.').last == json['type']),
        effect: json['effect'],
      );
}