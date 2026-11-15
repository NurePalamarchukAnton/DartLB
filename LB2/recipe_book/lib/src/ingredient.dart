/// Інгредієнт із кількістю.
///
/// [name] — назва, [amount] — кількість у базових одиницях рецепта.
final class Ingredient(final String name, final double amount) {
  /// Порівняння за назвою та кількістю.
  @override
  bool operator ==(Object other) =>
      other is Ingredient && other.name == name && other.amount == amount;

  /// Хеш за назвою та кількістю.
  @override
  int get hashCode => Object.hash(name, amount);

  /// Текстове подання `name:amount`.
  @override
  String toString() => '$name:$amount';

  /// JSON-подання.
  Map<String, Object?> toJson() => {'name': name, 'amount': amount};

  /// Створення з JSON.
  static Ingredient fromJson(Map<String, Object?> json) {
    return Ingredient(
      json['name'] as String,
      (json['amount'] as num).toDouble(),
    );
  }
}
