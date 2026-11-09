import 'identifiable.dart';

/// Домішка журналювання змін.
mixin Auditable on Identifiable {
  DateTime _updatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Час останнього оновлення.
  DateTime get updatedAt => _updatedAt;

  /// Фіксує момент оновлення.
  String touch() {
    _updatedAt = DateTime.now();
    return 'updated $id at $_updatedAt';
  }
}
