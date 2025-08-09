import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/mappers/course_mapper.dart';
import 'package:sigapp/grade_simulator/infrastructure/models/models.dart';

@LazySingleton(as: GradeTrackingRepository)
class GradeTrackingRepositoryImpl implements GradeTrackingRepository {
  final FirebaseFirestore _firestore;

  GradeTrackingRepositoryImpl(this._firestore);

  /// Typed reference to the course document with converter
  DocumentReference<CourseModel> _getTypedCourseRef(
    String studentCode,
    String courseCode,
  ) {
    return _firestore
        .collection('users')
        .doc(studentCode)
        .collection('gradeSimulations')
        .doc(courseCode)
        .withConverter<CourseModel>(
          fromFirestore: (snap, _) {
            final data = snap.data()!;
            // No need to add redundant fields - they're implicit in the path/document ID
            return CourseModel.fromJson(data);
          },
          toFirestore: (course, _) {
            final json = course.toJson();
            // Remove any redundant fields that shouldn't be stored
            json.remove('courseCode'); // Implicit in document ID
            json.remove('studentCode'); // Implicit in document path
            json.remove('id'); // Optional field removed
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
        .collection('users')
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

      // Try to read from cache first
      final cachedDoc = await courseRef.get(
        const GetOptions(source: Source.cache),
      );
      if (cachedDoc.exists && cachedDoc.data() != null) {
        return CourseMapper.toDomain(cachedDoc.data()!, courseCode: courseCode);
      }

      // If not in cache, go to server
      final serverDoc = await courseRef.get(
        const GetOptions(source: Source.server),
      );
      if (!serverDoc.exists || serverDoc.data() == null) return null;

      return CourseMapper.toDomain(serverDoc.data()!, courseCode: courseCode);
    } catch (e) {
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
      await courseRef.set(model);
      return tracking;
    } catch (e) {
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
    } catch (e) {
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
      final nextIndex =
          doc.exists && doc.data() != null
              ? ((doc.data()!['categories'] as Map<String, dynamic>?)?.length ??
                  0)
              : 0;

      // Add granular - only add the new category
      await rawRef.update({
        'categories.$nextIndex': {'name': categoryName, 'weight': weight},
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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

      // Find and delete grades of this category
      for (int i = 0; i < currentCourse.grades.length; i++) {
        if (currentCourse.grades[i].categoryIndex == categoryIndex) {
          updates['grades.$i'] = FieldValue.delete();
        }
      }

      // Execute all deletions in a single operation
      batch.update(rawRef, updates);
      await batch.commit();

      // Read the updated result
      final updated = await courseRef.get(
        const GetOptions(source: Source.server),
      );
      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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
      await rawRef.update({
        'categories.$categoryIndex.name': newName,
        'categories.$categoryIndex.weight': newWeight,
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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
      final nextGradeIndex =
          doc.exists && doc.data() != null
              ? ((doc.data()!['grades'] as Map<String, dynamic>?)?.length ?? 0)
              : 0;

      // Add granular - only add the new grade
      await rawRef.update({
        'grades.$nextGradeIndex': {
          'categoryIndex': categoryIndex,
          'name': gradeName,
          'score': score,
          'enabled': true,
        },
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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
      await rawRef.update({
        'grades.$gradeIndex': FieldValue.delete(),
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.server),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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
      await rawRef.update({
        'grades.$gradeIndex.name': newName,
        'grades.$gradeIndex.score': newScore,
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
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
      await rawRef.update({
        'grades.$gradeIndex.enabled': enabled,
        'lastModified': FieldValue.serverTimestamp(),
      });

      // Read the updated result from cache if possible
      final courseRef = _getTypedCourseRef(studentCode, courseCode);
      final updated = await courseRef.get(
        const GetOptions(source: Source.cache),
      );

      return CourseMapper.toDomain(updated.data()!, courseCode: courseCode);
    } catch (e) {
      throw Exception('Error toggling grade enabled: $e');
    }
  }
}
