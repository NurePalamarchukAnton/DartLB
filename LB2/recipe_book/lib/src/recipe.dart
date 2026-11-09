import 'auditable.dart';
import 'difficulty.dart';
import 'entity.dart';
import 'ingredient.dart';
import 'sample_data.dart';

/// Незмінний рецепт (первинний конструктор Dart 3.13).
final class Recipe(
  final String title,
  final String cuisine,
  final int cookMinutes,
  final Difficulty difficulty,
  final List<Ingredient> ingredients,
) extends Entity with Auditable {
  static final Map<String, Recipe> _cache = {};

  @override
  String get id => '$title#$cuisine';

  /// Час у годинах.
  double get cookHours => cookMinutes / 60;

  /// Кількість інгредієнтів.
  int get ingredientCount => ingredients.length;

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

  /// Фабрика з кешуванням.
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
      _sameIngredients(other.ingredients);

  bool _sameIngredients(List<Ingredient> other) {
    if (other.length != ingredients.length) {
      return false;
    }
    for (var i = 0; i < ingredients.length; i++) {
      if (ingredients[i].name != other[i].name ||
          ingredients[i].amount != other[i].amount) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    title,
    cuisine,
    cookMinutes,
    difficulty,
    Object.hashAll(ingredients.map((e) => Object.hash(e.name, e.amount))),
  );

  @override
  String toString() =>
      'Recipe($title, $cuisine, $cookMinutes, ${difficulty.label})';
}
