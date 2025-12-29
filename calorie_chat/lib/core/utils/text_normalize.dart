class TextNormalizer {
  static String normalize(String text) {
    return text.trim().toLowerCase();
  }

  static String normalizeForSearch(String text) {
    // Remove extra whitespace and normalize case for searching
    return text.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool matchesWildcard(String text, String pattern) {
    // Convert wildcard pattern to regex
    // * matches any characters
    String regexPattern = pattern
        .replaceAll(RegExp(r'[.+?^${}()|[\]\\]'), r'\$&') // Escape special chars
        .replaceAll('*', '.*'); // Convert * to .*

    return RegExp('^$regexPattern\$', caseSensitive: false).hasMatch(text);
  }
}
