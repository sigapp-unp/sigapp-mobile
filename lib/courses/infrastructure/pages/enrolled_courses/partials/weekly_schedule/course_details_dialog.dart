import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule.dart';
import 'package:sigapp/core/infrastructure/utils/time_utils.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/course_visibility_cubit.dart';

class CourseDetailsDialog extends StatelessWidget {
  final WeeklyScheduleWidgetItem event;

  const CourseDetailsDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CourseVisibilityCubit>(context);
    final isHidden = event.isHidden;

    return AlertDialog(
      title: Text(
        event.data.courseName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.location_on, 'Ubicación:', event.data.location),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, 'Horario:', _getDayAndTime()),
          const SizedBox(height: 12),
          // Checkbox para ocultar/desocultar el evento
          BlocBuilder<CourseVisibilityCubit, CourseVisibilityState>(
            builder: (context, state) {
              final isEventHidden =
                  state.hiddenEvents[event.data.id] ?? isHidden;

              return ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  isEventHidden ? 'No programado' : 'Marcar como no programado',
                ),
                subtitle:
                    isEventHidden
                        ? const Text(
                          'Este evento se opacará',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        )
                        : null,
                onTap: () => cubit.toggleEventVisibility(event, !isEventHidden),
                leading: Icon(
                  isEventHidden
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color:
                      isEventHidden
                          ? Theme.of(context).colorScheme.primary
                          : null,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }

  String _getDayAndTime() {
    String day;
    switch (event.data.weekday) {
      case 1:
        day = 'Lunes';
        break;
      case 2:
        day = 'Martes';
        break;
      case 3:
        day = 'Miércoles';
        break;
      case 4:
        day = 'Jueves';
        break;
      case 5:
        day = 'Viernes';
        break;
      case 6:
        day = 'Sábado';
        break;
      case 7:
        day = 'Domingo';
        break;
      default:
        day = '';
    }

    String time = TimeUtils.formatEventDuration(
      EventDuration(
        startHour: event.data.startHour,
        startMinute: event.data.startMinutes,
        endHour: event.data.endHour,
        endMinute: event.data.endMinutes,
      ),
    );

    return '$day, $time';
  }
}
