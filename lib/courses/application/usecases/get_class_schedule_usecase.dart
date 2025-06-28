import 'package:injectable/injectable.dart';
import 'package:sigapp/student/domain/entities/weekly_schedule_event.dart';
import 'package:sigapp/courses/domain/repositories/schedule_repository.dart';
import 'package:sigapp/courses/domain/value-objects/raw_class_schedule.dart';

@lazySingleton
class GetClassScheduleUsecase {
  static const String _eventsIdsPrefix = 'SIGAPP';

  final ScheduleRepository _scheduleRepository;
  // final CourseService _courseService;

  GetClassScheduleUsecase(this._scheduleRepository);

  Future<List<WeeklyScheduleEvent>> execute(String semesterId) async {
    final rawResult = await _scheduleRepository.getClassSchedule(semesterId);
    final result = _processClassSchedule(rawResult);
    return result;
  }

  List<WeeklyScheduleEvent> _processClassSchedule(
    List<RawClassSchedule> schedule,
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

      List<List<dynamic>> classDaysAndNames = [];

      if (classSchedule.monday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.monday, DateTime.monday]);
      }
      if (classSchedule.tuesday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.tuesday, DateTime.tuesday]);
      }
      if (classSchedule.wednesday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.wednesday, DateTime.wednesday]);
      }
      if (classSchedule.thursday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.thursday, DateTime.thursday]);
      }
      if (classSchedule.friday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.friday, DateTime.friday]);
      }
      if (classSchedule.saturday.isNotEmpty) {
        classDaysAndNames.add([classSchedule.saturday, DateTime.saturday]);
      }

      for (var dayAndName in classDaysAndNames) {
        final classInfo = dayAndName[0];
        final weekday = dayAndName[1];

        final parts = classInfo.split(' ? ');
        final courseName = parts[0];
        final classLocation = parts[1];

        final eventStart = calculateEventDateTime(classStartTime, weekday);
        final eventEnd = calculateEventDateTime(classEndTime, weekday);

        final id =
            '$_eventsIdsPrefix-[$courseName]-${eventStart.toString().substring(0, 16)}-${eventEnd.toString().substring(0, 16)}';
        weeklyScheduleEvents.add(
          WeeklyScheduleEvent(
            id: id,
            courseName: courseName,
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

  // TODO: move this to a separate usecase
  bool calculateIfEventIsOwnedByThisApp(String eventId) {
    return eventId.startsWith(_eventsIdsPrefix);
  }
}
