/// Запечатана ієрархія статусів приготування.
sealed class CookStatus {
  /// Опис статусу.
  String describe();
}

/// Рецепт ще не готували.
final class NotStarted extends CookStatus {
  @override
  String describe() => 'не розпочато';
}

/// Приготування в процесі.
final class InProgress extends CookStatus {
  InProgress(this.percent);

  /// Прогрес у відсотках.
  final int percent;

  @override
  String describe() => 'у процесі ($percent%)';
}

/// Страву приготовано.
final class Cooked extends CookStatus {
  Cooked(this.finishedAt);

  /// Дата завершення.
  final DateTime finishedAt;

  @override
  String describe() =>
      'готово ${finishedAt.toIso8601String().substring(0, 10)}';
}

/// Мітка статусу через вичерпний switch.
String statusLabel(CookStatus status) => switch (status) {
  NotStarted() => 'new',
  InProgress(:final percent) => 'progress:$percent',
  Cooked(:final finishedAt) => 'done:${finishedAt.year}',
};
