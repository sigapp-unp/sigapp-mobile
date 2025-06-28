// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/core/infrastructure/ui/not_used_pages/schedule_page/partials/export_to_calendar_cubit.dart';
import 'package:sigapp/student/domain/entities/weekly_schedule_event.dart';

class ExportToCalendar extends StatefulWidget {
  const ExportToCalendar({
    super.key,
    required this.weeklyEvents,
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;
  final List<WeeklyScheduleEvent> weeklyEvents;

  @override
  State<ExportToCalendar> createState() => _ExportToCalendarState();
}

class _ExportToCalendarState extends State<ExportToCalendar> {
  late final ExportToCalendarCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<ExportToCalendarCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.setup();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocProvider.value(
          value: _cubit,
          child: BlocBuilder<ExportToCalendarCubit, ExportToCalendarState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ErrorState) {
                return Center(child: Text(state.message));
              }
              if (state is SuccessState) {
                // build a body of a AlertDialog, it must be a "select"
                // for choosing a calendar
                // at te bottom, a button for exporting and a close button
                return Column(
                  children: [
                    const Text('Select a calendar'),
                    DropdownButton<String>(
                      value: state.selectedCalendar.id,
                      items:
                          state.calendars
                              .map(
                                (calendar) => DropdownMenuItem(
                                  value: calendar.id,
                                  child: Text(calendar.name ?? '(no name)'),
                                ),
                              )
                              .toList(),
                      onChanged: (calendarId) {
                        _cubit.selectCalendar(
                          state.calendars.firstWhere(
                            (calendar) => calendar.id == calendarId,
                          ),
                        );
                      },
                    ),
                    // date range picker
                    // const Text('Select a date range'),
                    // DateRangePickerWidget(
                    //   doubleMonth: false,
                    //   initialDateRange: DateRange(
                    //     state.startDate,
                    //     state.endDate,
                    //   ),
                    //   onDateRangeChanged: (range) {
                    //     if (range == null) {
                    //       return;
                    //     }
                    //     _cubit.selectDateRange(range.start, range.end);
                    //   },
                    // ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            try {
                              _cubit.export(
                                startDate: widget.startDate,
                                endDate: widget.endDate,
                                weeklyEvents: widget.weeklyEvents,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Exported to calendar'),
                                ),
                              );
                              Navigator.of(context).pop();
                            } catch (e, s) {
                              if (kDebugMode) {
                                print(e);
                                print(s);
                              }
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text('$e')));
                            }
                          },
                          child: const Text('Export'),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
