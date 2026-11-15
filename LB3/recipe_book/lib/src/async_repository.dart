import 'identifiable.dart';
import 'recipe.dart';

/// Асинхронне сховище рецептів.
class AsyncRecipeRepository<T extends Identifiable> {
  AsyncRecipeRepository({
    this.loadDelay = const Duration(milliseconds: 300),
    this.watchDelay = const Duration(milliseconds: 100),
  });

  /// Затримка операцій save/load/delete.
  final Duration loadDelay;

  /// Інтервал між подіями [watchAll].
  final Duration watchDelay;

  final Map<String, T> _items = {};

  /// Зберігає сутність.
  Future<T> save(T item) async {
    await Future<void>.delayed(loadDelay);
    _items[item.id] = item;
    return item;
  }

  /// Завантажує за [id].
  Future<T?> load(String id) async {
    await Future<void>.delayed(loadDelay);
    return _items[id];
  }

  /// Видаляє за [id].
  Future<bool> delete(String id) async {
    await Future<void>.delayed(loadDelay);
    return _items.remove(id) != null;
  }

  /// Синхронний доступ для демо.
  Iterable<T> get items => _items.values;

  /// Наповнення без затримки.
  void seed(Iterable<T> values) {
    for (final item in values) {
      _items[item.id] = item;
    }
  }

  /// Потік сутностей.
  Stream<T> watchAll() async* {
    print('watchAll: підписка активована');
    for (final item in _items.values) {
      await Future<void>.delayed(watchDelay);
      yield item;
    }
  }
}

/// Подія каталогу рецептів.
sealed class CatalogEvent {
  String get label;
}

/// Додано рецепт.
final class RecipeAdded extends CatalogEvent {
  RecipeAdded(this.recipe);
  final Recipe recipe;
  @override
  String get label => 'added:${recipe.id}';
}

/// Оновлено рецепт.
final class RecipeUpdated extends CatalogEvent {
  RecipeUpdated(this.recipe);
  final Recipe recipe;
  @override
  String get label => 'updated:${recipe.id}';
}

/// Видалено рецепт.
final class RecipeRemoved extends CatalogEvent {
  RecipeRemoved(this.id);
  final String id;
  @override
  String get label => 'removed:$id';
}
