# recipe_book (ЛР2)

Варіант 13 — рецепти й списки покупок. ООП-модель на базі даних ЛР1.

## Як запустити

```bash
dart pub get
dart run
dart analyze
dart fix --dry-run
dart test
```

## Чому така структура

Логіку тримаю в `lib/src/`, у `bin/` лише демо. Класи розклав так:
- `Recipe` / `Ingredient` — сутності
- `Repository` — узагальнене сховище
- `CookStatus` — sealed-статуси приготування
- `Difficulty` — enum зі членами
- `Auditable` — домішка журналювання
- `CatalogEntry` — інша гілка для тієї ж домішки
- `analytics` — records і pattern matching

Успадкування для спільного журналювання не підійшло: `Recipe` і `CatalogEntry` з різних гілок, тому взяв mixin з `on Identifiable`.

## Залежності

- `lints` — recommended-правила для `dart analyze`
- `test` — у `dev_dependencies`, для перевірок fromCsv / Repository / paceLabel

Пакет `path` прибрав: у ЛР2 шляхи не збираються, він лише був у шаблоні.

## `!`, `late`, `dynamic`

Не використовую.
