/// Роздільник полів рецепта.
const String fieldSeparator = ';';

/// Роздільник інгредієнтів у полі складу.
const String ingredientSeparator = '|';

/// Роздільник назви та кількості інгредієнта.
const String amountSeparator = ':';

/// Мінімальний час приготування (хвилини).
const int minCookMinutes = 1;

/// Максимальний час приготування (хвилини).
const int maxCookMinutes = 600;

/// Допустимі рівні складності.
const Set<String> allowedDifficulties = {'easy', 'medium', 'hard'};

/// Очікувана кількість полів у рядку рецепта.
///
/// Формат: назва;кухня;час;складність;інгредієнти
const int expectedFieldCount = 5;

/// Константний список вхідних рядків рецептів.
///
/// Інгредієнти: name:amount|name:amount. Серед записів є пошкоджені.
const List<String> rawRecipeLines = [
  'Borscht;Ukrainian;90;medium;beet:2|potato:3|cabbage:0.5|sour cream:1',
  'Carbonara;Italian;25;easy;spaghetti:400|egg:3|guanciale:150|pecorino:50',
  'Sushi Roll;Japanese;60;hard;rice:300|nori:4|salmon:200|avocado:1',
  'Guacamole;Mexican;15;easy;avocado:3|lime:1|onion:0.5|tomato:1',
  'Croissant;French;180;hard;flour:500|butter:250|yeast:10|milk:200',
  'Pad Thai;Thai;35;medium;rice noodles:250|shrimp:200|peanut:40|tamarind:30',
  'Hummus;Middle Eastern;20;easy;chickpea:400|tahini:60|garlic:2|lemon:1',
  'Paella;Spanish;70;medium;rice:400|saffron:1|chicken:500|mussel:300',
  'Ramen;Japanese;120;hard;broth:1500|noodle:400|egg:2|pork:300',
  'Pancakes;American;20;easy;flour:200|milk:250|egg:2|butter:30',
  'Moussaka;Greek;100;medium;eggplant:2|mince:500|bechamel:400|potato:3',
  'Falafel;Middle Eastern;45;medium;chickpea:300|herb:50|garlic:3|oil:100',
  'Tacos;Mexican;30;easy;tortilla:8|beef:400|salsa:150|cheese:100',
  'Incomplete;Italian;30',
  'BadTime;Ukrainian;slow;easy;potato:2',
  'BadDiff;French;40;extreme;butter:100',
  'BadAmount;Greek;50;easy;olive:xx|feta:2',
  'Ratatouille;French;55;medium;zucchini:2|eggplant:1|pepper:2|tomato:4',
  'Pho;Vietnamese;180;hard;broth:2000|rice noodle:400|beef:300|herbs:50',
];
