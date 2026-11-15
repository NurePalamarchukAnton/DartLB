import 'auditable.dart';
import 'entity.dart';

/// Службовий запис збірки рецептів.
///
/// [code] — ідентифікатор запису, [note] — коротка примітка.
final class CatalogEntry(final String code, final String note)
    extends Entity
    with Auditable {
  /// Збігається з [code].
  @override
  String get id => code;

  /// Текстове подання запису.
  @override
  String toString() => 'CatalogEntry($code, $note)';
}
