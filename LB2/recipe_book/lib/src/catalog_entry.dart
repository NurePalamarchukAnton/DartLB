import 'auditable.dart';
import 'entity.dart';

/// Службовий запис збірки рецептів.
final class CatalogEntry(final String code, final String note)
    extends Entity
    with Auditable {
  @override
  String get id => code;

  @override
  String toString() => 'CatalogEntry($code, $note)';
}
