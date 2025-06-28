import 'package:flutter/material.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/event.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/grid.dart';

class BodyWidget extends StatelessWidget {
  final List<WeeklyScheduleWidgetItem> events;
  final List<int> daysWithEvents;
  final int startHour;
  final int endHour;
  final BoxConstraints constraints;
  final double fontSize;
  final double hourWidth;
  final double rowHeight;
  final Function(WeeklyScheduleWidgetItem)? onEventTap;

  const BodyWidget({
    super.key,
    required this.events,
    required this.daysWithEvents,
    required this.startHour,
    required this.endHour,
    required this.constraints,
    required this.fontSize,
    required this.hourWidth,
    required this.rowHeight,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridWidget(
          daysWithEvents: daysWithEvents,
          startHour: startHour,
          endHour: endHour,
          constraints: constraints,
          hourWidth: hourWidth,
          rowHeight: rowHeight,
        ),
        ...events
            .where(
              (event) =>
                  event.data.startHour >= startHour &&
                  event.data.endHour <= endHour,
            )
            .map(
              (event) => EventWidget(
                event: event,
                constraints: constraints,
                daysWithEvents: daysWithEvents,
                startHour: startHour,
                fontSize: fontSize,
                rowHeight: rowHeight,
                hourWidth: hourWidth,
                onTap: onEventTap,
              ),
            ),
      ],
    );
  }
}
