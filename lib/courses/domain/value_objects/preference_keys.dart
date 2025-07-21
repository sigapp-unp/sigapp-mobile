/// Centralized preference keys to avoid magic strings
class PreferenceKeys {
  // Private constructor to prevent instantiation
  const PreferenceKeys._();

  // Schedule hidden events - stores list of hidden event IDs
  static const String scheduleHiddenEvents = 'schedule_hidden_events';

  // Course chain preferences - using nested structure for better organization
  static const String courseChain = 'course_chain';
  static const String courseChainHighlightCriticalPath =
      'course_chain.highlight_critical_path';
  static const String courseChainViewMode = 'course_chain.view_mode';
}
