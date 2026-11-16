# recipe_book (лабораторна робота 3)

Варіант 13 — рецепти й списки покупок. Асинхронний шар поверх моделі ЛР2:
`Future` / `async` / `await`, `Stream`, `Isolate.run`, модульні тести.

## Як запустити

```bash
dart pub get
dart analyze
dart format .
dart test
dart run
```

## Чому така структура

Логіку тримаю в `lib/src/`, у `bin/` лише точка входу. Для ЛР3 додано:
- `async_repository.dart` — `AsyncRecipeRepository` (`save` / `load` / `delete` → `Future`) і події каталогу
- `async_demos.dart` — усі демонстрації пунктів порядку виконання (забутий await, Stopwatch, ParallelWaitError, async*, StreamController, broadcast, конвеєр)
- `heavy_compute.dart` — підрахунок простих чисел і `Isolate.run`
- `test/async_repository_test.dart` — ≥6 тестів (`group`, `setUp`, `expectLater`)

Доменні типи (`Recipe`, `Ingredient`, `Auditable`) узгоджені з ЛР2: `id` кешу враховує час і склад, у `Ingredient` є `==` / `hashCode`, у документації `Recipe` не називається «повністю незмінним» — змінним лишається лише журнал `_updatedAt`.

## Залежності

- `lints` — `recommended` плюс `unawaited_futures`, `discarded_futures`, strict-casts/inference
- `test` — у `dev_dependencies` (для ЛР3 тести обов’язкові)

Пакет `path` прибрав: у ЛР3 шляхи не збираються, він лишився б лише зі шаблону `dart create`.

## `!`, `late`, `dynamic`

У коді застосунку не використовую. `late` є лише в тестах (`setUp`).
