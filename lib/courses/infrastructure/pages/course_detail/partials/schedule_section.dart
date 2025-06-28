import 'package:flutter/material.dart';
import 'package:sigapp/core/infrastructure/utils/time_utils.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/components/table_info.dart';
import 'package:sigapp/student/domain/value_objects/enrolled_course.dart';

class ScheduleSectionWidget extends StatelessWidget {
  const ScheduleSectionWidget({super.key, required this.enrolledCourse});

  final EnrolledCourse enrolledCourse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Horario',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          subtitle: TableInfoWidget([
            ['Grupo', enrolledCourse.data.group],
            ['Sección', enrolledCourse.data.section],
          ]),
        ),
        ListTile(
          title: Text('Semana'),
          subtitle: TableInfoWidget(
            (() {
              final events = [...enrolledCourse.scheduleEvents];
              events.sort((a, b) => a.weekday.compareTo(b.weekday));
              return events.map((e) {
                final weekdayName = TimeUtils.weekdayToString(e.weekday);
                return [
                  '${weekdayName[0].toUpperCase()}${weekdayName.substring(1)}',
                  TimeUtils.formatEventDuration(
                    EventDuration(
                      startHour: e.startHour,
                      startMinute: e.startMinutes,
                      endHour: e.endHour,
                      endMinute: e.endMinutes,
                    ),
                  ),
                ];
              }).toList();
            })(),
          ),
        ),
        ListTile(
          title: Text('Tiempo total'),
          subtitle: Text(
            (() {
              final total = enrolledCourse.scheduleEvents.fold(Duration(), (
                acc,
                e,
              ) {
                final duration = Duration(
                  hours: e.endHour - e.startHour,
                  minutes: e.endMinutes - e.startMinutes,
                );
                return acc + duration;
              });
              final h = total.inHours;
              final m = total.inMinutes.remainder(60);
              var result = '$h hora';
              if (h != 1) result += 's';
              if (m > 0) {
                result += ' y $m minuto';
                if (m != 1) result += 's';
              }
              return result;
            })(),
          ),
        ),
      ],
    );
  }
}
