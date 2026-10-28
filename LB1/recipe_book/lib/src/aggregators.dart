import 'parsers.dart';

/// Фільтрує рецепти за кухнею [cuisine].
List<RecipeRecord> filterByCuisine(List<RecipeRecord> recipes, String cuisine) {
  return recipes.where((recipe) => recipe.cuisine == cuisine).toList();
}

/// Перетворює рецепти на короткі підписи.
List<String> toShortLabels(List<RecipeRecord> recipes) {
  return recipes
      .map(
        (recipe) =>
            '${recipe.title} (${recipe.cookMinutes} хв, ${recipe.difficulty})',
      )
      .toList();
}

/// Середній час приготування через fold.
double averageCookMinutes(List<RecipeRecord> recipes) {
  if (recipes.isEmpty) {
    return 0;
  }
  final sum = recipes.fold<int>(0, (acc, recipe) => acc + recipe.cookMinutes);
  return sum / recipes.length;
}

/// Групує рецепти за кухнею.
Map<String, List<RecipeRecord>> groupByCuisine(List<RecipeRecord> recipes) {
  return recipes.fold<Map<String, List<RecipeRecord>>>({}, (acc, recipe) {
    final bucket = acc.putIfAbsent(recipe.cuisine, () => <RecipeRecord>[]);
    bucket.add(recipe);
    return acc;
  });
}

/// Середній час у кожній групі кухонь.
Map<String, double> averageCookByCuisine(List<RecipeRecord> recipes) {
  final groups = groupByCuisine(recipes);
  return {
    for (final entry in groups.entries)
      entry.key: averageCookMinutes(entry.value),
  };
}

/// Сортує рецепти за часом, потім за кількістю інгредієнтів.
List<RecipeRecord> sortRecipes(
  List<RecipeRecord> recipes, {
  bool ascending = true,
}) {
  final copy = [...recipes];
  copy.sort((a, b) {
    final byTime = a.cookMinutes.compareTo(b.cookMinutes);
    if (byTime != 0) {
      return ascending ? byTime : -byTime;
    }
    final byIngredients = a.ingredients.length.compareTo(b.ingredients.length);
    return ascending ? byIngredients : -byIngredients;
  });
  return copy;
}

/// Найдовший за часом рецепт або повідомлення за замовчуванням.
String longestRecipeLabel(List<RecipeRecord> recipes) {
  if (recipes.isEmpty) {
    return 'каталог порожній';
  }
  final best = recipes.reduce((a, b) => a.cookMinutes >= b.cookMinutes ? a : b);
  return '${best.title} (${best.cookMinutes} хв)';
}
