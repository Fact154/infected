import 'package:flutter/material.dart';
import '../utils/card_normalizer.dart'; // Импортируем нормализатор

class EnlargedCard extends StatelessWidget {
  final String cardName;
  final VoidCallback onDismiss;
  final int? imageVariant;

  const EnlargedCard({
    required this.cardName,
    required this.onDismiss,
    this.imageVariant,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Предотвращаем закрытие при нажатии на саму карту
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    CardNormalizer.getImageAssetPath(cardName, imageVariant: imageVariant),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Ошибка загрузки изображения для $cardName: $error');
                      return Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              cardName,
                              style: const TextStyle(fontSize: 16),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}