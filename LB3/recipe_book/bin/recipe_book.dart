import 'package:recipe_book/recipe_book.dart';

Future<void> main(List<String> arguments) async {
  final recipes = <Recipe>[];
  for (final line in rawRecipeLines) {
    try {
      recipes.add(Recipe.fromCsv(line));
    } on FormatException {
      // пропускаємо
    }
  }

  final repo = AsyncRecipeRepository<Recipe>(
    loadDelay: const Duration(milliseconds: 50),
    watchDelay: const Duration(milliseconds: 30),
  );
  repo.seed(recipes);

  await demoForgottenAwait(repo);
  await demoStopwatch();
  await demoParallelErrors();
  await demoUncaughtAsync();
  await demoAsyncStar(repo);
  await demoController();
  await demoBroadcast();
  await demoStreamPipeline(repo);
  await demoIsolate();
}
