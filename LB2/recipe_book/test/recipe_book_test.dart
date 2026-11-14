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

  test('cached не змішує рецепти з однаковою назвою й кухнею', () {
    final short = Recipe.cached(
      title: 'Borscht',
      cuisine: 'Ukrainian',
      cookMinutes: 60,
      difficulty: Difficulty.easy,
      ingredients: [Ingredient('beet', 1)],
    );
    final long = Recipe.cached(
      title: 'Borscht',
      cuisine: 'Ukrainian',
      cookMinutes: 120,
      difficulty: Difficulty.hard,
      ingredients: [Ingredient('beet', 2), Ingredient('potato', 3)],
    );
    expect(identical(short, long), isFalse);
    expect(short.cookMinutes, 60);
    expect(long.cookMinutes, 120);
    expect(short.id == long.id, isFalse);
  });

  test('paceLabel використовує when', () {
    final recipe = Recipe.fromCsv('Guacamole;Mexican;15;easy;avocado:3');
    expect(paceLabel(recipe), 'швидкий');
  });
}
