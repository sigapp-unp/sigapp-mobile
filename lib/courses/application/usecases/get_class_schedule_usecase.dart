import 'package:injectable/injectable.dart';
import 'package:sigapp/student/domain/entities/weekly_schedule_event.dart';
import 'package:sigapp/courses/domain/repositories/schedule_repository.dart';
import 'package:sigapp/courses/domain/value-objects/raw_class_schedule.dart';
import 'package:sigapp/courses/domain/entities/enrolled_course_data.dart';

@lazySingleton
class GetClassScheduleUsecase {
  // static const String _eventsIdsPrefix = 'SIGAPP';

  final ScheduleRepository _scheduleRepository;

  GetClassScheduleUsecase(this._scheduleRepository);

  /// Execute with course mapping for better event IDs
  Future<List<WeeklyScheduleEvent>> execute(
    String semesterId, {
    List<EnrolledCourseData>? enrolledCourses,
  }) async {
    final rawResult = await _scheduleRepository.getClassSchedule(semesterId);

    // Create course name to code mapping if enrolled courses are provided
    Map<String, String>? courseMapping;
    if (enrolledCourses != null) {
      courseMapping = _createCourseNameToCodeMapping(enrolledCourses);
    }

    final result = _processClassSchedule(rawResult, semesterId, courseMapping);
    return result;
  }

  List<WeeklyScheduleEvent> _processClassSchedule(
    List<RawClassSchedule> schedule,
    String semesterId,
    Map<String, String>? courseMapping,
  ) {
    // Map<String, Color> courseColorMap = {};

    List<WeeklyScheduleEvent> weeklyScheduleEvents = [];
    // List<Color> colorPalette = [
    //   Colors.purple,
    //   Colors.green,
    //   Colors.orange,
    //   Colors.blue,
    //   Colors.yellow,
    //   Colors.red,
    //   Colors.cyan,
    //   Colors.teal,
    //   Colors.indigo,
    //   Colors.pink,
    // ];

    // Color assignColorToCourse(String courseName) {
    //   if (!courseColorMap.containsKey(courseName)) {
    //     courseColorMap[courseName] =
    //         colorPalette[courseColorMap.length % colorPalette.length];
    //   }
    //   return courseColorMap[courseName]!;
    // }

    DateTime calculateEventDateTime(DateTime baseTime, int targetWeekday) {
      DateTime currentDate = DateTime.now();
      int currentWeekday = currentDate.weekday;
      int daysDifference = (targetWeekday - currentWeekday) % 7;
      if (daysDifference < 0) daysDifference += 7;
      return DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day + daysDifference,
        baseTime.hour,
        baseTime.minute,
      );
    }

    DateTime parseTimestamp(String timestamp) {
      final timestampPattern = RegExp(r'\/Date\((\d+)\)\/');
      final match = timestampPattern.firstMatch(timestamp);
      if (match != null) {
        final milliseconds = int.parse(match.group(1)!);
        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      }
      throw const FormatException("Invalid timestamp format");
    }

    for (var classSchedule in schedule) {
      final classStartTime = parseTimestamp(classSchedule.startHour);
      final classEndTime = parseTimestamp(classSchedule.endHour);
      // print(classSchedule);

      List<(String classInfo, int weekday)> classDaysAndNames = [];

      if (classSchedule.monday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.monday, DateTime.monday));
      }
      if (classSchedule.tuesday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.tuesday, DateTime.tuesday));
      }
      if (classSchedule.wednesday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.wednesday, DateTime.wednesday));
      }
      if (classSchedule.thursday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.thursday, DateTime.thursday));
      }
      if (classSchedule.friday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.friday, DateTime.friday));
      }
      if (classSchedule.saturday.isNotEmpty) {
        classDaysAndNames.add((classSchedule.saturday, DateTime.saturday));
      }

      for (var dayAndName in classDaysAndNames) {
        final (classInfo, weekday) = dayAndName;

        final parts = classInfo.split(' ? ');
        final courseName = parts[0];
        final classLocation = parts[1];

        // Try to get the course code from the mapping
        final courseCode =
            courseMapping != null
                ? _getCourseCodeFromName(courseName, courseMapping)
                : null;

        final eventStart = calculateEventDateTime(classStartTime, weekday);
        final eventEnd = calculateEventDateTime(classEndTime, weekday);
        final id =
            '${semesterId}_${courseCode ?? courseName}_${eventStart.hour}_${eventStart.minute}';

        weeklyScheduleEvents.add(
          WeeklyScheduleEvent(
            id: id,
            courseName: courseName,
            // courseCode: courseCode,
            // semesterId: semesterId,
            weekday: weekday,
            startHour: eventStart.hour,
            startMinutes: eventStart.minute,
            endHour: eventEnd.hour,
            endMinutes: eventEnd.minute,
            // color: _courseService.getBackgroundColor(courseName),
            location: classLocation,
          ),
        );
      }
    }
    return weeklyScheduleEvents;
  }

  // // TODO: move this to a separate usecase
  // bool calculateIfEventIsOwnedByThisApp(String eventId) {
  //   return eventId.startsWith(_eventsIdsPrefix);
  // }

  Map<String, String> _createCourseNameToCodeMapping(
    List<EnrolledCourseData> enrolledCourses,
  ) {
    final mapping = <String, String>{};

    for (final course in enrolledCourses) {
      // Map the full course name to the course code
      mapping[course.courseName] = course.courseCode;
    }

    return mapping;
  }

  String? _getCourseCodeFromName(
    String courseName,
    Map<String, String> mapping,
  ) {
    // Direct lookup first
    if (mapping.containsKey(courseName)) {
      return mapping[courseName];
    }

    // Fallback: try to find a course that contains this name
    // This handles cases where the schedule might have slightly different formatting
    for (final entry in mapping.entries) {
      if (entry.key.contains(courseName) || courseName.contains(entry.key)) {
        return entry.value;
      }
    }

    return null; // No match found
  }
}
