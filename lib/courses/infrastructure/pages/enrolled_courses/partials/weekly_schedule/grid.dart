import 'package:flutter/material.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/hour_label.dart';

class GridWidget extends StatelessWidget {
  final List<int> daysWithEvents;
  final int startHour;
  final int endHour;
  final BoxConstraints constraints;
  final double hourWidth;
  final double rowHeight;
  final double littleRayLength;

  const GridWidget({
    super.key,
    required this.daysWithEvents,
    required this.startHour,
    required this.endHour,
    required this.constraints,
    required this.hourWidth,
    required this.rowHeight,
  }) : littleRayLength = hourWidth * 0.15;

  @override
  Widget build(BuildContext context) {
    final numOfRows = endHour - startHour;
    return Column(
      children: List.generate(numOfRows, (hour) {
        return Row(
          children: [
            HourLabelWidget(
              hour: startHour + hour,
              rowHeight: rowHeight,
              littleRayLength: littleRayLength,
              hourWidth: hourWidth,
            ),
            Expanded(
              child: Row(
                children: List.generate(daysWithEvents.length, (dayIndex) {
                  return Expanded(
                    child: Container(
                      height: rowHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          left:
                              dayIndex == 0
                                  ? BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                  )
                                  : BorderSide.none,
                          right:
                              dayIndex != daysWithEvents.length - 1
                                  ? BorderSide(
                                    color: Colors.grey.withValues(alpha: 0.5),
                                  )
                                  : BorderSide.none,
                          bottom: BorderSide(
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      })..addAll([
        Row(
          children: [
            SizedBox(width: hourWidth, height: littleRayLength),
            for (var dayIndex in List.generate(
              daysWithEvents.length,
              (index) => index,
            ))
              Container(
                width:
                    (constraints.maxWidth - hourWidth) / daysWithEvents.length,
                height: littleRayLength,
                decoration: BoxDecoration(
                  border: Border(
                    left:
                        dayIndex == 0
                            ? BorderSide(
                              color: Colors.grey.withValues(alpha: 0.5),
                            )
                            : BorderSide.none,
                    right:
                        dayIndex != daysWithEvents.length - 1
                            ? BorderSide(
                              color: Colors.grey.withValues(alpha: 0.5),
                            )
                            : BorderSide.none,
                  ),
                ),
              ),
          ],
        ),
      ]),
    );
  }
}
