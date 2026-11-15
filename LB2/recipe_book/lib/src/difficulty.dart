/// Рівень складності рецепта з ваговим коефіцієнтом.
enum Difficulty {
  /// Легкий рівень.
  easy('easy', 1),

  /// Середній рівень.
  medium('medium', 2),

  /// Складний рівень.
  hard('hard', 3);

  /// Створює елемент перелічення.
  const Difficulty(this.label, this.weight);

  /// Текстова мітка.
  final String label;

  /// Вага для сортування.
  final int weight;

  /// Розбір мітки або виняток.
  static Difficulty fromLabel(String value) {
    for (final item in Difficulty.values) {
      if (item.label == value.toLowerCase()) {
        return item;
      }
    }
    throw FormatException('невідома складність: $value');
  }

  /// Чи вважається складність високою.
  bool get isChallenging => weight >= 2;
}
