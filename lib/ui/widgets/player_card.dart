import 'package:flutter/material.dart';
import '../../models/card_type.dart';
import '../utils/card_normalizer.dart'; // Импортируем нормализатор

class PlayerCard extends StatelessWidget {
  final String cardName;
  final double width;
  final double height;
  final CardType? cardType;
  final int? imageVariant;
  static final Map<String, Image> _imageCache = {};

  const PlayerCard({
    required this.cardName,
    this.cardType,
    this.width = 100,
    this.height = 150,
    this.imageVariant,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: _imageCache[cardName] ??= Image.asset(
          CardNormalizer.getImageAssetPath(cardName, imageVariant: imageVariant),
          fit: BoxFit.cover,
          cacheWidth: width.toInt(),
          cacheHeight: height.toInt(),
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Ошибка загрузки изображения для $cardName: $error');
            return Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 4),
                  Text(
                    cardName,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}