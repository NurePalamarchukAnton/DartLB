import 'identifiable.dart';

/// Узагальнене сховище сутностей.
class Repository<T extends Identifiable> {
  final Map<String, T> _items = {};

  /// Додає сутність.
  void add(T item) => _items[item.id] = item;

  /// Шукає за [id].
  T? findById(String id) => _items[id];

  /// Усі значення.
  Iterable<T> get all => _items.values;

  /// Фільтр.
  Iterable<T> where(bool Function(T) test) => _items.values.where(test);

  /// Розмір.
  int get length => _items.length;
}
