import 'package:injectable/injectable.dart';
import 'package:sigapp/shared/application/repositories/student_session_repository.dart';
import 'package:sigapp/courses/application/usecases/base_grade_tracking_usecase.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart';

@injectable
class ManageCategoriesUseCase extends BaseGradeTrackingUseCase {
  final GradeTrackingRepository _repository;

  ManageCategoriesUseCase(
    this._repository,
    StudentSessionRepository studentSessionRepository,
  ) : super(studentSessionRepository);

  Future<CourseTracking> addCategory({
    required String courseCode,
    required String categoryName,
    required double weight,
  }) async {
    return _repository.addCategory(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
      categoryName: categoryName,
      weight: weight,
    );
  }

  Future<CourseTracking> updateCategory({
    required String courseCode,
    required String categoryId,
    required String newName,
    required double newWeight,
  }) async {
    return _repository.updateCategory(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
      newName: newName,
      newWeight: newWeight,
    );
  }

  Future<CourseTracking> removeCategory({
    required String courseCode,
    required String categoryId,
  }) async {
    return _repository.deleteCategory(
      studentCode: await getStudentCode(),
      courseCode: courseCode,
      categoryId: categoryId,
    );
  }
}
