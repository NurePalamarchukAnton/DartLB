import 'auditable.dart';
import 'entity.dart';

/// Службовий запис збірки рецептів (друга гілка з [Auditable]).
///
/// [code] — код запису, [note] — примітка.
final class CatalogEntry(final String code, final String note)
    extends Entity
    with Auditable {
  /// Ідентифікатор збігається з кодом запису.
  @override
  String get id => code;

  @override
  String toString() => 'CatalogEntry($code, $note)';
}
