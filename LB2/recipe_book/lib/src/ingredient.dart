/// Інгредієнт із кількістю.
final class Ingredient(final String name, final double amount) {
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
