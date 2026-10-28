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
});

/// Результат розбору одного рядка.
typedef ParseOutcome = ({RecipeRecord? recipe, String? error});

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

  if (title.isEmpty || cuisine.isEmpty || ingredientsRaw.isEmpty) {
    return (recipe: null, error: 'порожнє текстове поле');
  }
  if (cookMinutes == null) {
    return (recipe: null, error: 'некоректний час: ${parts[2]}');
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
    ),
    error: null,
  );
}

/// Перевіряє формат назви через регулярний вираз з іменованими групами.
bool isTitleFormatValid(String title) {
  final match = titlePattern.firstMatch(title);
  return match?.namedGroup('title') != null;
}

/// Маскує назву кухні, залишаючи першу літеру другого слова за наявності.
String maskCuisine(String cuisine) {
  return cuisine.replaceAllMapped(RegExp(r'^(?<first>\S+)\s+(?<last>\S+)$'), (
    match,
  ) {
    final regexMatch = match as RegExpMatch;
    final first = regexMatch.namedGroup('first') ?? '';
    final last = regexMatch.namedGroup('last') ?? '';
    if (last.isEmpty) {
      return cuisine;
    }
    return '$first ${last[0]}.';
  });
}

/// Умовна дата додавання рецепта до збірки (для арифметики дат).
DateTime publishedAt(String title) {
  final seed = title.hashCode.abs() % 365;
  return DateTime(2025, 1, 1).add(Duration(days: seed));
}

/// Вік запису рецепта в днях через DateTime.difference.
int ageInDays(String title, {DateTime? referenceDate}) {
  final now = referenceDate ?? DateTime.now();
  return now.difference(publishedAt(title)).inDays;
}

/// Фабрика предикатів за максимальною тривалістю — приклад замикання.
bool Function(RecipeRecord) cookAtMost(int minutes) {
  return (recipe) => recipe.cookMinutes <= minutes;
}

/// Лічильник успішно оброблених записів із захопленням змінної.
int Function() createProcessedCounter() {
  var count = 0;
  return () {
    count += 1;
    return count;
  };
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
