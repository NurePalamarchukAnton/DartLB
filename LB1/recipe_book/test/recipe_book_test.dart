import 'package:recipe_book/recipe_book.dart';
import 'package:test/test.dart';

void main() {
  test('parseLine розбирає коректний рядок', () {
    final outcome = parseLine('Borscht;Ukrainian;90;medium;beet:2|potato:3');
    expect(outcome.error, isNull);
    expect(outcome.recipe?.title, 'Borscht');
    expect(outcome.recipe?.ingredients.length, 2);
  });

  test('parseLine фіксує пошкоджений рядок', () {
    final outcome = parseLine('Incomplete;Only;Two');
    expect(outcome.recipe, isNull);
    expect(outcome.error, isNotNull);
  });

  test('averageCookMinutes обчислює середнє', () {
    final recipes = [
      (
        title: 'A',
        cuisine: 'X',
        cookMinutes: 20,
        difficulty: 'easy',
        ingredients: <Ingredient>[(name: 'a', amount: 1)],
      ),
      (
        title: 'B',
        cuisine: 'X',
        cookMinutes: 40,
        difficulty: 'easy',
        ingredients: <Ingredient>[(name: 'b', amount: 1)],
      ),
    ];
    expect(averageCookMinutes(recipes), 30);
  });
}
