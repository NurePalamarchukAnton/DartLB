import 'identifiable.dart';

/// Домішка журналювання змін поверх [Identifiable].
///
/// Тримає окремий змінний стан `_updatedAt`, тож типи з цією домішкою
/// не варто описувати як повністю незмінні — незмінним може бути лише
/// зміст домену, а не метадані аудиту.
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
