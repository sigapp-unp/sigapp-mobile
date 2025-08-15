import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Resilient Firestore read helper.
///
/// Strategy:
/// 1) Try cache for immediate UX.
/// 2) Fetch from server with brief backoff retries on transient errors.
/// 3) Final cache fallback (offline scenario).
///
/// Returns `null` when the document doesn't exist.
/// Rethrows the last FirebaseException if non-retriable or all retries fail.
Future<T?> getWithResilience<T>(
  DocumentReference<T> ref, {
  List<int> backoff = const [150, 350, 800], // ms
  Set<String> retriableCodes = const {
    'unavailable',
    'deadline-exceeded',
    'aborted',
  },
}) async {
  // 1) Try cache first
  try {
    final cache = await ref.get(const GetOptions(source: Source.cache));
    if (cache.exists && cache.data() != null) return cache.data();
  } catch (_) {
    // Ignore cache read errors
  }

  // 2) Try server with jittered backoff on transient errors
  final rng = math.Random();
  FirebaseException? last;
  for (final baseMs in backoff) {
    try {
      final server = await ref.get(const GetOptions(source: Source.server));
      return server.exists ? server.data() : null;
    } on FirebaseException catch (e) {
      last = e;
      if (!retriableCodes.contains(e.code)) rethrow;
      final ms = (baseMs * (0.8 + rng.nextDouble() * 0.4)).round();
      await Future.delayed(Duration(milliseconds: ms));
    }
  }

  // 3) Final cache fallback
  try {
    final fallback = await ref.get(const GetOptions(source: Source.cache));
    if (fallback.exists && fallback.data() != null) return fallback.data();
  } catch (_) {}

  if (last != null) throw last;
  return null;
}
