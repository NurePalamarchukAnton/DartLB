import 'auditable.dart';
import 'difficulty.dart';
import 'entity.dart';
import 'ingredient.dart';
import 'sample_data.dart';

/// Рецепт із фіксованим змістом полів і журналом через [Auditable].
///
/// Поля страви (`title`, склад тощо) задаються конструктором і не
/// перезаписуються; час оновлення з домішки лишається змінним через [touch].
final class Recipe(
  final String title,
  final String cuisine,
  final int cookMinutes,
  final Difficulty difficulty,
  final List<Ingredient> ingredients,
) extends Entity with Auditable {
  static final Map<String, Recipe> _cache = {};

  @override
  String get id =>
      '$title#$cuisine#$cookMinutes#${difficulty.label}#$_ingredientsKey';

  /// Час у годинах.
  double get cookHours => cookMinutes / 60;

  /// Кількість інгредієнтів.
  int get ingredientCount => ingredients.length;

  String get _ingredientsKey =>
      ingredients.map((i) => '${i.name}$amountSeparator${i.amount}').join(
        ingredientSeparator,
      );

  /// Іменований конструктор з CSV.
  factory Recipe.fromCsv(String line) {
    final parts = line.split(fieldSeparator);
    if (parts.length != expectedFieldCount) {
      throw FormatException(
        'очікувано $expectedFieldCount полів, отримано ${parts.length}',
      );
    }
    final cookMinutes = int.tryParse(parts[2].trim());
    if (cookMinutes == null) {
      throw FormatException('некоректний час: ${parts[2]}');
    }
    final difficulty = Difficulty.fromLabel(parts[3].trim());
    final ingredients = <Ingredient>[];
    for (final chunk in parts[4].split(ingredientSeparator)) {
      final pair = chunk.split(amountSeparator);
      if (pair.length != 2) {
        throw FormatException('некоректний інгредієнт: $chunk');
      }
      final amount = double.tryParse(pair[1].trim());
      if (amount == null) {
        throw FormatException('некоректна кількість: ${pair[1]}');
      }
      ingredients.add(Ingredient(pair[0].trim(), amount));
    }
    return Recipe.cached(
      title: parts[0].trim(),
      cuisine: parts[1].trim(),
      cookMinutes: cookMinutes,
      difficulty: difficulty,
      ingredients: List.unmodifiable(ingredients),
    );
  }

  /// Фабрика з кешуванням за повним [id] (назва, кухня, час, складність, склад).
  factory Recipe.cached({
    required String title,
    required String cuisine,
    required int cookMinutes,
    required Difficulty difficulty,
    required List<Ingredient> ingredients,
  }) {
    final recipe = Recipe(title, cuisine, cookMinutes, difficulty, ingredients);
    return _cache.putIfAbsent(recipe.id, () => recipe);
  }

  @override
  bool operator ==(Object other) =>
      other is Recipe &&
      other.title == title &&
      other.cuisine == cuisine &&
      other.cookMinutes == cookMinutes &&
      other.difficulty == difficulty &&
      _listEquals(ingredients, other.ingredients);

  @override
  int get hashCode => Object.hash(
    title,
    cuisine,
    cookMinutes,
    difficulty,
    Object.hashAll(ingredients),
  );

  static bool _listEquals(List<Ingredient> a, List<Ingredient> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() =>
      'Recipe($title, $cuisine, $cookMinutes, ${difficulty.label})';
}
