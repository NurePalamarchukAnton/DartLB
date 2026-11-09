import 'recipe.dart';

/// Підсумок вибірки рецептів.
typedef RecipeStats = ({int count, double averageCookMinutes});

/// Обчислює статистику.
RecipeStats summarize(Iterable<Recipe> recipes) {
  final list = recipes.toList();
  if (list.isEmpty) {
    return (count: 0, averageCookMinutes: 0);
  }
  final sum = list.fold<int>(0, (acc, r) => acc + r.cookMinutes);
  return (count: list.length, averageCookMinutes: sum / list.length);
}

/// Класифікація за часом зіставленням зі зразком.
String paceLabel(Recipe recipe) => switch (recipe) {
  Recipe(cookMinutes: final m) when m <= 30 => 'швидкий',
  Recipe(cookMinutes: final m) when m <= 90 => 'середній',
  _ => 'довгий',
};
