import 'package:injectable/injectable.dart';
import 'package:sigapp/courses/application/usecases/get_class_schedule_usecase.dart';
import 'package:sigapp/courses/domain/repositories/courses_repository.dart';
import 'package:sigapp/courses/domain/value_objects/enrolled_course.dart';

@lazySingleton
class GetEnrolledCoursesUsecase {
  final CoursesRepository _coursesRepository;
  final GetClassScheduleUsecase _getClassScheduleUsecase;

  final Map<String, List<EnrolledCourse>> _cache = {};

  GetEnrolledCoursesUsecase(
    this._coursesRepository,
    this._getClassScheduleUsecase,
  );

  Future<List<EnrolledCourse>> execute(String semesterId) async {
    if (_cache.containsKey(semesterId)) {
      return _cache[semesterId]!;
    }

    final enrolledCoursesData = await _coursesRepository.getEnrolledCourses(
      semesterId,
    );
    final scheduleEvents = await _getClassScheduleUsecase.execute(
      semesterId,
      enrolledCourses: enrolledCoursesData,
    );

    final enrolledCourses =
        enrolledCoursesData
            .map(
              (data) => EnrolledCourse(
                data: data,
                scheduleEvents:
                    scheduleEvents
                        .where(
                          (event) => data.courseName.contains(event.courseName),
                        )
                        .toList(),
              ),
            )
            .toList();

    _cache[semesterId] = enrolledCourses;

    return enrolledCourses;
  }
}
