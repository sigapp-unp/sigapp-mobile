import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';
import 'package:sigapp/courses/infrastructure/pages/career/widgets/course_subtitle.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/course_detail_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/course_detail_page.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/course_avatar.dart';

class CourseItemWidget extends StatelessWidget {
  final Color color;

  const CourseItemWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailCubit, CourseDetailState>(
      builder: (context, state) {
        return switch (state) {
          CourseDetailEmptyState() => Container(),
          CourseDetailReadyState() => InkWell(
            onTap: () {
              final cubit = BlocProvider.of<CourseDetailCubit>(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: cubit,
                        child: CourseDetailPageWidget(color: color),
                      ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16, top: 8),
                  child: CourseAvatarWidget(
                    courseName: state.course.data.courseName,
                    color: color,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(state.course.data.courseName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        CourseSubtitleWidget(
                          children: [
                            // Tipo de curso
                            state.course.data.courseType == CourseType.mandatory
                                ? CourseSubtitleWidgetItem(
                                  text: 'Obligatorio',
                                  icon: Icons.school,
                                )
                                : state.course.data.courseType ==
                                    CourseType.elective
                                ? CourseSubtitleWidgetItem(
                                  text: 'Electivo',
                                  icon: MdiIcons.leaf,
                                )
                                : CourseSubtitleWidgetItem(
                                  text: 'Tipo desconocido',
                                ),
                            // Créditos
                            CourseSubtitleWidgetItem(
                              text:
                                  state.course.data.credits == 1
                                      ? '1 crédito'
                                      : '${state.course.data.credits} créditos',
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            final readyState = state;
                            final additionalItems =
                                <CourseSubtitleWidgetItem?>[
                                  // Notas
                                  switch (readyState.grades) {
                                    CourseDetailGradesStateLoading() =>
                                      CourseSubtitleWidgetItem(
                                        text: 'Notas',
                                        loading: true,
                                      ),
                                    CourseDetailGradesStateLoaded(
                                      :final value,
                                    ) =>
                                      switch (value.grade) {
                                        CourseGradePreviewLoaded(
                                          value: final grade,
                                        ) =>
                                          CourseSubtitleWidgetItem(
                                            text:
                                                '${grade.isPartial ? 'Nota parcial' : 'Nota final'}: ${grade.value.toStringAsFixed(2)}',
                                            icon:
                                                grade.isPartial
                                                    ? MdiIcons
                                                        .clipboardCheckOutline
                                                    : MdiIcons.clipboardCheck,
                                          ),
                                        _ => null,
                                      },
                                    _ => null,
                                  },
                                  // Syllabus
                                  switch (readyState.syllabus) {
                                    CourseDetailSyllabusStateLoading() =>
                                      CourseSubtitleWidgetItem(
                                        text: 'Syllabus',
                                        loading: true,
                                      ),
                                    CourseDetailSyllabusStateLoaded() =>
                                      CourseSubtitleWidgetItem(
                                        text: 'Syllabus',
                                        icon: Icons.check_circle,
                                      ),
                                    _ => null,
                                  },
                                ].whereType<CourseSubtitleWidgetItem>().toList();

                            if (additionalItems.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return CourseSubtitleWidget(
                              children: additionalItems,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        };
      },
    );
  }
}
