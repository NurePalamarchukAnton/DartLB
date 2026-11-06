import 'sample_data.dart';

/// Інгредієнт рецепта з кількістю.
typedef Ingredient = ({String name, double amount});

/// Запис рецепта після успішного розбору.
typedef RecipeRecord = ({
  String title,
  String cuisine,
  int cookMinutes,
  String difficulty,
  List<Ingredient> ingredients,
  DateTime addedAt,
});

/// Результат розбору одного рядка.
typedef ParseOutcome = ({RecipeRecord? recipe, String? error});

/// Лічильник оброблених записів: збільшення й читання без зміни.
typedef ProcessedCounter = ({void Function() increment, int Function() read});

/// Регулярний вираз для перевірки назви рецепта з іменованою групою.
final RegExp titlePattern = RegExp(r"^(?<title>[A-Za-z0-9 \-']+)$");

/// Розбирає рядок [line] у запис рецепта.
ParseOutcome parseLine(String line) {
  final parts = line.split(fieldSeparator);
  if (parts.length != expectedFieldCount) {
    return (
      recipe: null,
      error: 'очікувано $expectedFieldCount полів, отримано ${parts.length}',
    );
  }

  final title = parts[0].trim();
  final cuisine = parts[1].trim();
  final cookMinutes = int.tryParse(parts[2].trim());
  final difficulty = parts[3].trim().toLowerCase();
  final ingredientsRaw = parts[4].trim();
  final addedAt = DateTime.tryParse(parts[5].trim());

  if (title.isEmpty || cuisine.isEmpty || ingredientsRaw.isEmpty) {
    return (recipe: null, error: 'порожнє текстове поле');
  }
  if (cookMinutes == null) {
    return (recipe: null, error: 'некоректний час: ${parts[2]}');
  }
  if (addedAt == null) {
    return (recipe: null, error: 'некоректна дата: ${parts[5]}');
  }

  final ingredients = <Ingredient>[];
  for (final chunk in ingredientsRaw.split(ingredientSeparator)) {
    final pair = chunk.split(amountSeparator);
    if (pair.length != 2) {
      return (recipe: null, error: 'некоректний інгредієнт: $chunk');
    }
    final amount = double.tryParse(pair[1].trim());
    if (amount == null) {
      return (recipe: null, error: 'некоректна кількість: ${pair[1]}');
    }
    ingredients.add((name: pair[0].trim(), amount: amount));
  }

  return (
    recipe: (
      title: title,
      cuisine: cuisine,
      cookMinutes: cookMinutes,
      difficulty: difficulty,
      ingredients: ingredients,
      addedAt: addedAt,
    ),
    error: null,
  );
}

/// Перевіряє формат назви через регулярний вираз з іменованими групами.
bool isTitleFormatValid(String title) {
  final match = titlePattern.firstMatch(title);
  return match?.namedGroup('title') != null;
}

/// Маскує назву кухні, залишаючи ініціал другого слова.
String maskCuisine(String cuisine) {
  final match = RegExp(r'^(?<first>\S+)\s+(?<last>\S+)$').firstMatch(cuisine);
  if (match == null) {
    return cuisine;
  }
  final first = match.namedGroup('first') ?? '';
  final last = match.namedGroup('last') ?? '';
  if (last.isEmpty) {
    return cuisine;
  }
  return '$first ${last[0]}.';
}

/// Вік запису рецепта в днях від дати додавання [addedAt].
int ageInDays(DateTime addedAt, {DateTime? referenceDate}) {
  final now = referenceDate ?? DateTime.now();
  return now.difference(addedAt).inDays;
}

/// Фабрика предикатів за максимальною тривалістю — приклад замикання.
bool Function(RecipeRecord) cookAtMost(int minutes) {
  return (recipe) => recipe.cookMinutes <= minutes;
}

/// Лічильник успішно оброблених записів із захопленням змінної.
ProcessedCounter createProcessedCounter() {
  var count = 0;
  return (
    increment: () {
      count += 1;
    },
    read: () => count,
  );
}

/// Формує текстовий список покупок з кількох рецептів.
List<String> buildShoppingList(List<RecipeRecord> recipes) {
  final totals = <String, double>{};
  for (final recipe in recipes) {
    for (final item in recipe.ingredients) {
      totals.update(
        item.name,
        (value) => value + item.amount,
        ifAbsent: () => item.amount,
      );
    }
  }
  final names = totals.keys.toList()..sort();
  return [for (final name in names) '$name: ${totals[name]}'];
}
