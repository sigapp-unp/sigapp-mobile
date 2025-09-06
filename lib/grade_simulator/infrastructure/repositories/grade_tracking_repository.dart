import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/mappers/course_mapper.dart';
import 'package:sigapp/grade_simulator/infrastructure/models/models.dart';
import 'package:sigapp/shared/infrastructure/firestore/resilient_read.dart';

/// Repository for managing grade simulation data in Firestore
/// (courses, categories, and grades) with an **offline-first** and
/// **resilient read** approach.
///
/// ## Key Design Goals
/// 1. **Maintainability** – Clear separation between typed references
///    (`_getTypedCourseRef`) and raw references (`_getRawCourseRef`).
/// 2. **Reliability** – Cache-first reads, retry on transient errors,
///    and final fallback to cache.
/// 3. **Efficiency** – Granular updates to minimize write costs and
///    reduce conflict potential.
///
/// ## Resilient Read Strategy (`_getWithResilience`)
/// 1. **Cache First** – Immediate UX, avoids network latency.
/// 2. **Server Fetch w/ Backoff & Jitter** – Retries for transient
///    errors (`unavailable`, `deadline-exceeded`, `aborted`) with
///    increasing delays (150ms, 350ms, 800ms) and ±20% jitter.
/// 3. **Cache Fallback** – Guarantees availability even offline.
///
/// ## Why This Matters
/// - Improves perceived app reliability under unstable networks.
/// - Prevents “thundering herd” on server during outages.
/// - Transparent recovery for the user: always returns the best
///   available data.
///
/// ## Reliability Notes
/// - Works with Firestore’s persistent cache.
/// - Post-write reads use cache for consistency, remote refresh
///   happens in background.
/// - Extensible: add telemetry for retries, source used (cache/server),
///   and error codes for observability.
///
/// ## Maintenance Tips
/// - Update the transient error list if Firestore introduces new ones.
/// - Tune backoff values based on latency/timeout changes.
/// - Keep `CourseModel` and converters in sync.
/// =============================================================
@LazySingleton(as: GradeTrackingRepository)
class GradeTrackingRepositoryImpl implements GradeTrackingRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  GradeTrackingRepositoryImpl(this._firestore, this._logger);

  // Normalize Firestore-returned values so they can be JSON-encoded safely
  // (handles Timestamp, DateTime, DocumentReference, Lists and Maps).
  dynamic _toJsonSafe(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();
    if (value is DocumentReference) return value.path;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _toJsonSafe(v)));
    }
    if (value is List) return value.map(_toJsonSafe).toList();
    return value;
  }

  // Safe JSON logging helper to avoid repeating try/catch every time.
  void _safeLog(String message, dynamic value, {String? extra}) {
    try {
      final normalized = _toJsonSafe(value);
      final extraStr = extra != null ? ' $extra' : '';
      _logger.i('$message ${jsonEncode(normalized)}$extraStr');
    } catch (e, s) {
      _logger.w('$message failed to jsonEncode: $e', error: e, stackTrace: s);
    }
  }

  /// Typed reference to the course document with converter
  DocumentReference<CourseModel> _getTypedCourseRef(
    String studentCode,
    String courseCode,
  ) {
    return _firestore
        .collection('students')
        .doc(studentCode)
        .collection('gradeSimulations')
        .doc(courseCode)
        .withConverter<CourseModel>(
          fromFirestore: (snap, _) {
            final data = snap.data()!;
            // Log raw snapshot data (normalized) for debugging/inspection
            try {
              final normalized = _toJsonSafe(data);
              _logger.i(
                '[GRADE_REPO] fromFirestore ${snap.reference.path} -> ${jsonEncode(normalized)} (cache:${snap.metadata.isFromCache})',
              );
            } catch (e) {
              _logger.w(
                '[GRADE_REPO] Failed to jsonEncode snapshot for ${snap.reference.path}: $e',
              );
            }

            // No need to add redundant fields - they're implicit in the path/document ID
            return CourseModel.fromJson(data);
          },
          toFirestore: (course, _) {
            final json = course.toJson();
            // Remove any redundant fields that shouldn't be stored
            json.remove('courseCode'); // Implicit in document ID
            json.remove('studentCode'); // Implicit in document path
            json.remove('id'); // Optional field removed
            try {
              _logger.i(
                '[GRADE_REPO] toFirestore (course doc) -> ${jsonEncode(_toJsonSafe(json))}',
              );
            } catch (e) {
              _logger.w(
                '[GRADE_REPO] Failed to jsonEncode model toFirestore: $e',
              );
            }
            return json;
          },
        );
  }

  /// Raw reference for granular updates (cost optimization)
  DocumentReference<Map<String, dynamic>> _getRawCourseRef(
    String studentCode,
    String courseCode,
  ) {
    return _firestore
        .collection('students')
        .doc(studentCode)
        .collection('gradeSimulations')
        .doc(courseCode);
  }

  // =============================================
  // GradeTrackingCourseRepository Implementation
  // =============================================

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final data = await getWithResilience(courseRef);
      if (data != null) {
        _safeLog(
          '[GRADE_REPO] getCourseTracking raw ->',
          data.toJson(),
          extra: '(cache:${false})',
        );
      } else {
        _logger.i(
          '[GRADE_REPO] getCourseTracking returned null for ${courseRef.path}',
        );
      }
      if (data == null) return null;
      return CourseMapper.toDomain(data, courseCode: courseCode);
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error getting course tracking',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error getting course tracking: $e');
    }
  }

  @override
  Future<CourseTracking> create({
    required String studentCode,
    required CourseTracking tracking,
  }) async {
    try {
      final model = CourseMapper.toInfrastructure(tracking, () => '');
      final courseRef = _getTypedCourseRef(studentCode, tracking.courseCode);
      _safeLog('[GRADE_REPO] create set ->', model.toJson());
      await courseRef.set(model);
      return tracking;
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error creating course tracking',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error creating course tracking: $e');
    }
  }

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) async {
    try {
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      await courseRef.delete();
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error deleting course tracking',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error deleting course tracking: $e');
    }
  }

  // =============================================
  // GradeTrackingCategoryRepository Implementation
  // =============================================

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);

      // Get current document to calculate next index
      final doc = await rawRef.get();
      _safeLog('[GRADE_REPO] addCategory currentDoc ->', doc.data());
      final nextIndex =
          doc.exists && doc.data() != null
              ? ((doc.data()!['categories'] as Map<String, dynamic>?)?.length ??
                  0)
              : 0;

      // Add granular - only add the new category
      final updates = {
        'categories.$nextIndex': {'name': categoryName, 'weight': weight},
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] addCategory update ->', updates);
      await rawRef.update(updates);

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog('[GRADE_REPO] addCategory updated ->', updated.data()!.toJson());
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e('[GRADE_REPO] Error adding category', error: e, stackTrace: s);
      throw Exception('Error adding category: $e');
    }
  }

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) async {
    try {
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final rawRef = _getRawCourseRef(studentCode, courseCode);

      // Get the current course to identify grades to delete
      final doc = await courseRef.get();
      _safeLog(
        '[GRADE_REPO] deleteCategory currentCourse ->',
        doc.data()?.toJson(),
      );
      if (!doc.exists || doc.data() == null) {
        throw Exception('Course not found');
      }

      final currentCourse = doc.data()!;
      final categoryIndex = int.tryParse(categoryId);

      if (categoryIndex == null ||
          categoryIndex >= currentCourse.categories.length) {
        throw Exception('Invalid category index');
      }

      // Prepare batch operation for multiple deletions
      final batch = _firestore.batch();
      final updates = <String, dynamic>{
        'lastModified': FieldValue.serverTimestamp(),
      };

      // Delete category
      updates['categories.$categoryIndex'] = FieldValue.delete();

      // Find and delete grades of this category (grades is a Map in infra)
      currentCourse.grades.forEach((key, gradeModel) {
        if (gradeModel.categoryIndex == categoryIndex) {
          updates['grades.$key'] = FieldValue.delete();
        }
      });

      // Execute all deletions in a single operation
      _safeLog('[GRADE_REPO] deleteCategory batch updates ->', updates);
      batch.update(rawRef, updates);
      await batch.commit();

      // Read the updated result (cache-first after write)
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog(
        '[GRADE_REPO] deleteCategory updated ->',
        updated.data()!.toJson(),
      );
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error deleting category',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error deleting category: $e');
    }
  }

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);
      final categoryIndex = int.tryParse(categoryId);

      if (categoryIndex == null) {
        throw Exception('Invalid category index');
      }

      // Granular update - only the fields that change
      final updates = {
        'categories.$categoryIndex.name': newName,
        'categories.$categoryIndex.weight': newWeight,
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] updateCategory update ->', updates);
      await rawRef.update(updates);

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog(
        '[GRADE_REPO] updateCategory updated ->',
        updated.data()!.toJson(),
      );
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error updating category',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error updating category: $e');
    }
  }

  // =============================================
  // GradeTrackingGradeRepository Implementation
  // =============================================

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);
      final categoryIndex = int.tryParse(categoryId);

      if (categoryIndex == null) {
        throw Exception('Invalid category index');
      }

      // Get current document to calculate next grade index
      final doc = await rawRef.get();
      _safeLog('[GRADE_REPO] addGrade currentDoc ->', doc.data());
      final nextGradeIndex =
          doc.exists && doc.data() != null
              ? ((doc.data()!['grades'] as Map<String, dynamic>?)?.length ?? 0)
              : 0;

      // Add granular - only add the new grade
      final updates = {
        'grades.$nextGradeIndex': {
          'categoryIndex': categoryIndex,
          'name': gradeName,
          'score': score,
          'enabled': true,
        },
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] addGrade update ->', updates);
      await rawRef.update(updates);

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog('[GRADE_REPO] addGrade updated ->', updated.data()!.toJson());
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e('[GRADE_REPO] Error adding grade', error: e, stackTrace: s);
      throw Exception('Error adding grade: $e');
    }
  }

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);
      final gradeIndex = int.tryParse(gradeId);

      if (gradeIndex == null) {
        throw Exception('Invalid grade index');
      }

      // Granular delete - only delete the specific grade
      final updates = {
        'grades.$gradeIndex': FieldValue.delete(),
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] deleteGrade update ->', updates);
      await rawRef.update(updates);

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog('[GRADE_REPO] deleteGrade updated ->', updated.data()!.toJson());
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e('[GRADE_REPO] Error deleting grade', error: e, stackTrace: s);
      throw Exception('Error deleting grade: $e');
    }
  }

  @override
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);
      final gradeIndex = int.tryParse(gradeId);

      if (gradeIndex == null) {
        throw Exception('Invalid grade index');
      }

      // Granular update - only the fields that change
      final updates = {
        'grades.$gradeIndex.name': newName,
        'grades.$gradeIndex.score': newScore,
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] updateGrade update ->', updates);
      await rawRef.update(updates);

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog('[GRADE_REPO] updateGrade updated ->', updated.data()!.toJson());
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e('[GRADE_REPO] Error updating grade', error: e, stackTrace: s);
      throw Exception('Error updating grade: $e');
    }
  }

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) async {
    try {
      final rawRef = _getRawCourseRef(studentCode, courseCode);
      final gradeIndex = int.tryParse(gradeId);

      if (gradeIndex == null) {
        throw Exception('Invalid grade index');
      }

      // Granular update - only the enabled field
      final updates = {
        'grades.$gradeIndex.enabled': enabled,
        'lastModified': FieldValue.serverTimestamp(),
      };
      _safeLog('[GRADE_REPO] toggleGradeEnabled update ->', updates);
      await rawRef.update(updates);

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      _safeLog(
        '[GRADE_REPO] toggleGradeEnabled updated ->',
        updated.data()!.toJson(),
      );
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e, s) {
      _logger.e(
        '[GRADE_REPO] Error toggling grade enabled',
        error: e,
        stackTrace: s,
      );
      throw Exception('Error toggling grade enabled: $e');
    }
  }
}
