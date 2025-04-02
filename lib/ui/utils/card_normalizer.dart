// lib/utils/card_normalizer.dart
import 'dart:math';

class CardNormalizer {
  /// Нормализует имя карты для использования в пути к файлу.
  static String normalizeName(String name) {
    return name
        .replaceAll('!', '') // Убираем восклицательные знаки
        .replaceAll('?', '') // Убираем вопросительные знаки
        .replaceAll('...', '') // Убираем многоточие
        .replaceAll('ё', 'е') // Заменяем ё на е для файловой системы
        .replaceAll(' ', '_') // Заменяем пробелы на подчеркивания
        .replaceAll('.', '') // Убираем точки
        .toLowerCase(); // Приводим к нижнему регистру
  }

  /// Возвращает путь к изображению карты с учетом специальных случаев.
  static String getImageAssetPath(String cardName, {int? imageVariant}) {
    final normalizedName = normalizeName(cardName);

    if (normalizedName == 'нечто') {
      return 'assets/cards/нечто.png';
    }

    if (normalizedName == 'заражение') {
      if (imageVariant != null) {
        return 'assets/cards/заражение$imageVariant.png';
      }
      // Генерация случайного варианта для заражения
      final infectionNumber = Random().nextInt(4) + 1;
      return 'assets/cards/заражение$infectionNumber.png';
    }

    // Для остальных карт используем нормализованное имя
    return 'assets/cards/$normalizedName.png';
  }
}