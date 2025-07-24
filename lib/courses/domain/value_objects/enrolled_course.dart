import 'package:sigapp/courses/domain/entities/enrolled_course_data.dart';
import 'package:sigapp/student/domain/entities/weekly_schedule_event.dart';

class EnrolledCourse {
  final EnrolledCourseData data;
  final List<WeeklyScheduleEvent> scheduleEvents;

  EnrolledCourse({required this.data, required this.scheduleEvents});
}
