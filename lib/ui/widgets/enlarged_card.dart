import 'package:flutter/material.dart';

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

  String _getImageAssetPath(String name) {
    // Нормализуем имя файла
    String normalizedName = name
      .replaceAll('!', '')  // Убираем восклицательные знаки
      .replaceAll('?', '')  // Убираем вопросительные знаки
      .replaceAll('...', '') // Убираем многоточие
      .replaceAll('ё', 'е') // Заменяем ё на е для файловой системы
      .replaceAll(' ', '_') // Заменяем пробелы на подчеркивания
      .replaceAll('.', '') // Убираем точки
      .toLowerCase(); // Приводим к нижнему регистру

    // Для карты Нечто используем специальный путь
    if (normalizedName == 'нечто') {
      return 'assets/cards/нечто.png';
    }

    // Для карты Заражение используем вариант изображения
    if (normalizedName == 'заражение' && imageVariant != null) {
      return 'assets/cards/заражение$imageVariant.png';
    }

    // Для остальных карт используем нормализованное имя
    return 'assets/cards/$normalizedName.png';
  }

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
                    _getImageAssetPath(cardName),
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