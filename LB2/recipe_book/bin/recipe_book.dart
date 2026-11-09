import 'package:recipe_book/recipe_book.dart';

void main(List<String> arguments) {
  final repo = Repository<Recipe>();
  final errors = <String>[];

  for (final line in rawRecipeLines) {
    try {
      final recipe = Recipe.fromCsv(line);
      recipe.touch();
      repo.add(recipe);
    } on FormatException catch (error) {
      errors.add(error.message);
    }
  }

  print('=== ООП-книга рецептів ===');
  print('Записів: ${repo.length}, помилок розбору: ${errors.length}');
  for (final error in errors) {
    print('  ! $error');
  }

  print('\n=== == і hashCode у Set ===');
  final a = Recipe.cached(
    title: 'Demo',
    cuisine: 'Test',
    cookMinutes: 20,
    difficulty: Difficulty.easy,
    ingredients: [Ingredient('salt', 1)],
  );
  final b = Recipe('Demo', 'Test', 20, Difficulty.easy, [
    Ingredient('salt', 1),
  ]);
  print('a == b: ${a == b}, Set.length: ${{a, b}.length}');

  print('\n=== Sealed CookStatus ===');
  final statuses = <CookStatus>[
    NotStarted(),
    InProgress(50),
    Cooked(DateTime(2026, 3, 1)),
  ];
  for (final status in statuses) {
    print('${status.describe()} -> ${statusLabel(status)}');
  }

  print('\n=== Домішка Auditable ===');
  print(CatalogEntry('svc-1', 'службовий').touch());
  print(repo.all.first.touch());

  print('\n=== Розширення String ===');
  print('ukrainian'.normalizedCuisine);

  print('\n=== Статистика (record) ===');
  final RecipeStats(:count, :averageCookMinutes) = summarize(repo.all);
  print('count=$count, average=${averageCookMinutes.toStringAsFixed(1)}');

  print('\n=== Pattern matching ===');
  for (final recipe in repo.where((r) => r.cuisine == 'Japanese').take(3)) {
    print('${recipe.title}: ${paceLabel(recipe)}');
  }

  print('\n=== Difficulty enum ===');
  print(
    Difficulty.values
        .where((d) => d.isChallenging)
        .map((d) => '${d.label}(${d.weight})')
        .join(', '),
  );
}
