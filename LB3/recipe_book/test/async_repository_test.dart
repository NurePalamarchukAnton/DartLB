import 'package:recipe_book/recipe_book.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncRecipeRepository', () {
    late AsyncRecipeRepository<Recipe> repo;
    late Recipe recipe;

    setUp(() {
      repo = AsyncRecipeRepository<Recipe>(
        loadDelay: Duration.zero,
        watchDelay: Duration.zero,
      );
      recipe = Recipe.fromCsv('Borscht;Ukrainian;90;medium;beet:2|potato:3');
    });

    test('save і load', () async {
      await repo.save(recipe);
      expect(await repo.load(recipe.id), recipe);
    });

    test('load null', () async {
      expect(await repo.load('missing'), isNull);
    });

    test('delete false', () async {
      expect(await repo.delete('missing'), isFalse);
    });

    test('delete true', () async {
      await repo.save(recipe);
      expect(await repo.delete(recipe.id), isTrue);
    });

    test('watchAll порядок', () async {
      final second = Recipe.fromCsv('Guacamole;Mexican;15;easy;avocado:3');
      await repo.save(recipe);
      await repo.save(second);
      await expectLater(
        repo.watchAll().map((item) => item.title),
        emitsInOrder(['Borscht', 'Guacamole', emitsDone]),
      );
    });

    test('помилка save', () async {
      Future<Recipe> failing() async {
        await Future<void>.delayed(Duration.zero);
        throw StateError('сховище недоступне');
      }

      await expectLater(failing(), throwsStateError);
    });
  });
}
