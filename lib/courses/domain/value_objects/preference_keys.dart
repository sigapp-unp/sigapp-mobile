/// Centralized preference keys to avoid magic strings
class PreferenceKeys {
  // Private constructor to prevent instantiation
  const PreferenceKeys._();

  // Course visibility preferences
  static const String courseVisibility = 'course_visibility';

  // Course chain preferences - using nested structure for better organization
  static const String courseChain = 'course_chain';
  static const String courseChainHighlightCriticalPath =
      'course_chain.highlight_critical_path';
  static const String courseChainViewMode = 'course_chain.view_mode';

  /// Helper method to build course visibility key for specific event
  static String courseVisibilityEvent(String eventId) =>
      '$courseVisibility.$eventId';
}
