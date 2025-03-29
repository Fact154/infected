import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/card_type.dart';

class PlayerCard extends StatelessWidget {
  final String cardName;
  final double width;
  final double height;
  final CardType? cardType; // Добавляем тип карты

  // Кеш для SVG
  static final Map<String, SvgPicture> _svgCache = {};

  const PlayerCard({
    required this.cardName,
    this.cardType, // Новый параметр
    this.width = 100,
    this.height = 150,
    Key? key,
  }) : super(key: key);

  String _getSvgAssetPath(String name) {
    final formattedName = name
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('!', '')
        .replaceAll('.', '')
        .replaceAll('ё', 'е');
    return 'assets/cards/$formattedName.svg';
  }

  // Метод для определения цвета по типу карты
  Color _getCardColor() {
    switch(cardType) {
      case CardType.Infection:
        return Colors.red[100]!;
      case CardType.Panic:
        return Colors.orange[100]!;
      case CardType.Event:
        return Colors.blue[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget _buildCardImage() {
    try {
      final path = _getSvgAssetPath(cardName);
      debugPrint('Loading SVG from: $path'); // Логирование пути
      return _svgCache[cardName] ??= SvgPicture.asset(
        path,
        semanticsLabel: cardName,
        placeholderBuilder: (_) => const Icon(Icons.credit_card), // Запасной виджет
      );
    } catch (e) {
      debugPrint('Error loading SVG for $cardName: $e');
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red),
          Text(cardName, style: const TextStyle(fontSize: 10)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _getCardColor(), // Используем новый метод
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cardName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _svgCache[cardName] ??= SvgPicture.asset(
                _getSvgAssetPath(cardName),
                semanticsLabel: cardName,
                placeholderBuilder: (_) => const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}