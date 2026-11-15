/// Розширення рядків для книги рецептів.
extension RecipeStringX on String {
  /// Нормалізує назву кухні.
  String get normalizedCuisine {
    final trimmed = trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }
}
