import 'package:sigapp/courses/domain/entities/scheduled_course.dart';
import 'package:sigapp/shared/domain/entities/raw_course_requirement.dart';
import 'package:sigapp/courses/domain/entities/enrolled_course_data.dart';

abstract class CoursesRepository {
  Future<List<EnrolledCourseData>> getEnrolledCourses(String semesterId);
  // TODO: USE
  Future<List<RawCourseRequirement>> getCourseRequirements(String courseCode);
  Future<List<ScheduledCourse>> getScheduledCourses();
}
