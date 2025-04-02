import 'card_model.dart';
// import 'card_type.dart';

enum Role { Human, Thing, Infected }

class PlayerModel {
  final String name;
  Role role;
  List<CardModel> hand = []; 
  bool isQuarantined = false;
  bool isBarricaded = false; // Новое поле
  bool isAlive = true;

  PlayerModel({required this.name, required this.role});

  bool canSeePlayer(PlayerModel otherPlayer) {
    // Если текущий игрок - Нечто, он видит всех зараженных
    if (role == Role.Thing) {
      return otherPlayer.role == Role.Infected;
    }
    // Если текущий игрок заражен, он видит только Нечто
    if (role == Role.Infected) {
      return otherPlayer.role == Role.Thing;
    }
    // Обычные игроки не видят особые роли других игроков
    return false;
  }

  void addCard(CardModel card) {
    if (card.name == "Заражение!" && role == Role.Infected) {
      int infectionCount = hand.where((c) => c.name == "Заражение!").length;
      if (infectionCount >= 3) return;
    }
    hand.add(card);
  }


  @override
  String toString() => '$name ($role, ${hand.length} карт, ${isAlive ? "жив" : "мёртв"}, ${isQuarantined ? "в карантине" : ""}, ${isBarricaded ? "за баррикадой" : ""})';
Map<String, dynamic> toJson() => {
        'name': name,
        'role': role.toString().split('.').last,
        'hand': hand.map((c) => c.toJson()).toList(),
        'isQuarantined': isQuarantined,
        'isBarricaded': isBarricaded,
        'isAlive': isAlive,
      };

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final player = PlayerModel(
      name: json['name'],
      role: Role.values.firstWhere((r) => r.toString().split('.').last == json['role']),
    );
    player.hand = (json['hand'] as List)
        .map((c) => CardModel.fromJson(c))
        .toList()
        .cast<CardModel>(); // Явное приведение типа
    return player;
  }
}