import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';
import 'package:sigapp/grade_simulator/domain/entities/course_tracking.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_course_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_category_repository.dart';
import 'package:sigapp/grade_simulator/domain/repositories/grade_tracking_grade_repository.dart';
import 'package:sigapp/grade_simulator/infrastructure/repositories/remote/single_write_client.dart';
import 'course_remote_source.dart';
import 'category_remote_source.dart';
import 'grade_remote_source.dart';

/// Unified remote repository using composition for better maintainability
/// Delegates operations to specialized remote sources:
/// - CourseRemoteSource: course-level operations (GET, POST, DELETE)
/// - CategoryRemoteSource: category CRUD with JSONB patches
/// - GradeRemoteSource: grade CRUD with JSONB patches
///
/// Benefits of composition:
/// - Single responsibility per class
/// - Easy to test individual components
/// - Clear separation of concerns
/// - Reusable components across different contexts
@singleton
class RemoteGradeSimulatorRepository
    implements
        GradeTrackingCourseRepository,
        GradeTrackingCategoryRepository,
        GradeTrackingGradeRepository {
  final CourseRemoteSource _course;
  late final CategoryRemoteSource _category;
  late final GradeRemoteSource _grade;

  RemoteGradeSimulatorRepository(
    ApiGatewayClient client,
    Logger logger,
    SingleWriteClient patcher,
  ) : _course = CourseRemoteSource(client, logger) {
    _category = CategoryRemoteSource(_course, patcher, logger);
    _grade = GradeRemoteSource(_course, logger, client);
  }

  // 🎓 COURSE REPOSITORY IMPLEMENTATION (delegated to CourseRemoteSource)

  @override
  Future<CourseTracking?> getCourseTracking({
    required String studentCode,
    required String courseCode,
  }) => _course.fetch(studentCode: studentCode, courseCode: courseCode);

  @override
  Future<CourseTracking> create(CourseTracking tracking) =>
      _course.create(tracking);

  @override
  Future<void> deleteCourseTracking({
    required String studentCode,
    required String courseCode,
  }) => _course.delete(studentCode: studentCode, courseCode: courseCode);

  // 📂 CATEGORY REPOSITORY IMPLEMENTATION (delegated to CategoryRemoteSource)

  @override
  Future<CourseTracking> addCategory({
    required String studentCode,
    required String courseCode,
    required String categoryName,
    required double weight,
  }) => _category.addCategory(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryName: categoryName,
    weight: weight,
  );

  @override
  Future<CourseTracking> deleteCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
  }) => _category.deleteCategory(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
  );

  @override
  Future<CourseTracking> updateCategory({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) => _category.updateCategory(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    newName: newName,
    newWeight: newWeight,
  );

  @override
  Future<void> updateCategoriesField({
    required String studentCode,
    required String courseCode,
    required List<GradeCategory> categories,
  }) => _category.updateCategoriesField(
    studentCode: studentCode,
    courseCode: courseCode,
    categories: categories,
  );

  // 🎯 GRADE REPOSITORY IMPLEMENTATION (delegated to GradeRemoteSource)

  @override
  Future<CourseTracking> addGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeName,
    required double score,
  }) => _grade.addGrade(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    gradeName: gradeName,
    score: score,
  );

  @override
  Future<CourseTracking> deleteGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
  }) => _grade.deleteGrade(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    gradeId: gradeId,
  );

  @override
  Future<CourseTracking> updateGrade({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required String newName,
    required double newScore,
  }) => _grade.updateGrade(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    gradeId: gradeId,
    newName: newName,
    newScore: newScore,
  );

  @override
  Future<CourseTracking> toggleGradeEnabled({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required String gradeId,
    required bool enabled,
  }) => _grade.toggleGradeEnabled(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    gradeId: gradeId,
    enabled: enabled,
  );

  @override
  Future<void> updateGradesField({
    required String studentCode,
    required String courseCode,
    required String categoryId,
    required List<Grade> grades,
  }) => _grade.updateGradesField(
    studentCode: studentCode,
    courseCode: courseCode,
    categoryId: categoryId,
    grades: grades,
  );

  @override
  Future<void> updateMultipleCategoriesGrades({
    required String studentCode,
    required String courseCode,
    required Map<String, List<Grade>> gradesByCategory,
  }) => _grade.updateMultipleCategoriesGrades(
    studentCode: studentCode,
    courseCode: courseCode,
    gradesByCategory: gradesByCategory,
  );
}
