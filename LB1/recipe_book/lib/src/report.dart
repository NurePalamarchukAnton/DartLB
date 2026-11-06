import 'aggregators.dart';
import 'parsers.dart';

/// Формує текстовий звіт за списком [items].
String buildReport(
  List<RecipeRecord> items, {
  int topCount = 5,
  bool ascending = true,
  RecipeSortBy by = RecipeSortBy.cookMinutes,
  String separator = ' | ',
}) {
  final buffer = StringBuffer();
  final sorted = sortRecipes(items, by: by, ascending: ascending);
  final limit = topCount.clamp(0, sorted.length);

  buffer.writeln('Книга рецептів: звіт');
  buffer.writeln('Усього записів: ${items.length}');
  buffer.writeln(
    'Середній час: ${averageCookMinutes(items).toStringAsFixed(1)} хв',
  );
  buffer.writeln('Критерій: $by, ascending=$ascending');
  buffer.writeln('Топ-$limit:');

  for (var i = 0; i < limit; i++) {
    final recipe = sorted[i];
    buffer.writeln(
      '${i + 1}. ${recipe.title}$separator'
      '${recipe.cuisine}$separator'
      '${recipe.cookMinutes} хв$separator'
      '${recipe.ingredients.length} інгр.$separator'
      '${recipe.difficulty}',
    );
  }

  return buffer.toString();
}
