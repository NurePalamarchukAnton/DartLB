import 'package:recipe_book/recipe_book.dart';
import 'package:test/test.dart';

void main() {
  test('Recipe.fromCsv створює об’єкт', () {
    final recipe = Recipe.fromCsv(
      'Borscht;Ukrainian;90;medium;beet:2|potato:3',
    );
    expect(recipe.title, 'Borscht');
    expect(recipe.difficulty, Difficulty.medium);
  });

  test('Repository зберігає за id', () {
    final repo = Repository<Recipe>();
    final recipe = Recipe.fromCsv(
      'Borscht;Ukrainian;90;medium;beet:2|potato:3',
    );
    repo.add(recipe);
    expect(repo.findById(recipe.id)?.cookMinutes, 90);
  });

  test('paceLabel використовує when', () {
    final recipe = Recipe.fromCsv('Guacamole;Mexican;15;easy;avocado:3');
    expect(paceLabel(recipe), 'швидкий');
  });
}
