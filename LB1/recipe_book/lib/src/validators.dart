import 'parsers.dart';
import 'sample_data.dart';

/// Перевіряє діапазони значень рецепта й повертає перелік порушень.
List<String> validateRecipe(RecipeRecord recipe) {
  final issues = <String>[];

  if (recipe.cookMinutes < minCookMinutes ||
      recipe.cookMinutes > maxCookMinutes) {
    issues.add(
      'час ${recipe.cookMinutes} поза діапазоном '
      '[$minCookMinutes; $maxCookMinutes]',
    );
  }
  if (!allowedDifficulties.contains(recipe.difficulty)) {
    issues.add('складність "${recipe.difficulty}" не з $allowedDifficulties');
  }
  if (recipe.ingredients.isEmpty) {
    issues.add('порожній перелік інгредієнтів');
  }
  if (!isTitleFormatValid(recipe.title)) {
    issues.add('назва "${recipe.title}" не відповідає шаблону');
  }

  return issues;
}
