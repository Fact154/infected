import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String cardName; // Название карты

  const PlayerCard({required this.cardName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Ширина квадрата
      height: 100, // Высота квадрата
      decoration: BoxDecoration(
        color: Colors.grey[300], // Цвет фона карты
        border: Border.all(color: Colors.black, width: 2), // Граница
        borderRadius: BorderRadius.circular(8), // Закругленные углы
      ),
      child: Center(
        child: Text(
          cardName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}