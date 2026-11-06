import 'package:recipe_book/recipe_book.dart';

void main(List<String> arguments) {
  final counter = createProcessedCounter();
  final recipes = <RecipeRecord>[];
  final parseErrors = <String>[];

  for (final line in rawRecipeLines) {
    final outcome = parseLine(line);
    final recipe = outcome.recipe;
    if (recipe == null) {
      parseErrors.add('$line -> ${outcome.error}');
      continue;
    }
    recipes.add(recipe);
    counter.increment();
  }

  print('=== Розбір вхідних даних ===');
  print('Успішно: ${recipes.length}, помилок: ${parseErrors.length}');
  for (final error in parseErrors) {
    print('  ! $error');
  }

  print('\n=== Валідація ===');
  for (final recipe in recipes) {
    final issues = validateRecipe(recipe);
    if (issues.isNotEmpty) {
      print('${recipe.title}: ${issues.join('; ')}');
    }
  }

  print('\n=== Конвеєри ===');
  final italian = filterByCuisine(recipes, 'Italian');
  print('Italian (${italian.length}): ${toShortLabels(italian).join(', ')}');
  print('Середній час: ${averageCookMinutes(recipes).toStringAsFixed(1)} хв');

  print('\n=== Групування за кухнею ===');
  final averages = averageCookByCuisine(recipes);
  for (final entry in averages.entries) {
    print('${entry.key}: ${entry.value.toStringAsFixed(1)} хв');
  }

  print('\n=== Сортування за часом (зростання) ===');
  print(
    buildReport(
      recipes,
      topCount: 5,
      by: RecipeSortBy.cookMinutes,
      ascending: true,
    ),
  );

  print('=== Сортування за кількістю інгредієнтів (спадання) ===');
  print(
    buildReport(
      recipes,
      topCount: 5,
      by: RecipeSortBy.ingredientCount,
      ascending: false,
      separator: ' / ',
    ),
  );

  print('=== Замикання cookAtMost(30) ===');
  final quick = recipes.where(cookAtMost(30)).toList();
  print(toShortLabels(quick).join(', '));

  print('\n=== Список покупок (Italian) ===');
  print(buildShoppingList(italian).join(', '));

  print('\n=== Маскування кухні та вік запису ===');
  final forMask = recipes.firstWhere((recipe) => recipe.cuisine.contains(' '));
  print(
    '${forMask.cuisine} -> ${maskCuisine(forMask.cuisine)} | '
    'додано ${forMask.addedAt.toIso8601String().substring(0, 10)}, '
    'вік запису: ${ageInDays(forMask.addedAt)} днів',
  );

  print('\n=== Найдовший рецепт ===');
  print(longestRecipeLabel(recipes));
  print('Оброблено лічильником: ${counter.read()}');
}
