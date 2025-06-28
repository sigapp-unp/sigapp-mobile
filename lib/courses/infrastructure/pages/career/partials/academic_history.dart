import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/courses/domain/entities/academic_history_term.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/infrastructure/pages/career/components/grades_per_course_category_chart.dart';
import 'package:sigapp/courses/infrastructure/pages/career/components/weighted_average_evolution_chart.dart';
import 'package:sigapp/courses/infrastructure/pages/career/widgets/course_subtitle.dart';
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/empty_courses.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';

class CareerPageAcademicHistoryWidget extends StatelessWidget {
  const CareerPageAcademicHistoryWidget({
    super.key,
    required this.academicHistory,
    required this.report,
  });

  final List<AcademicHistoryTerm> academicHistory;
  final AcademicReport report;

  @override
  Widget build(BuildContext context) {
    if (academicHistory.isEmpty) {
      return EmptyCoursesWidget(message: 'No disponible en este momento');
    }
    return ListView(
      children: [
        if (academicHistory.length > 1)
          WeightedAverageEvolutionChartWidget(academicHistory: academicHistory),
        ...academicHistory.map((term) {
          return ExpansionTile(
            title: Text('Semestre ${term.term.name}'),
            children: [
              if (term.statistics != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildStatisticsSection(
                                  context,
                                  title: 'Promedio ponderado',
                                  data: [
                                    ..._maybeAddAverages(
                                      normal:
                                          term.statistics!.termWeightedAverage,
                                      pass:
                                          term
                                              .statistics!
                                              .termWeightedAveragePassed,
                                      normalLabel: 'Semestral',
                                      passLabel: 'Semestral (aprobatorio)',
                                    ),
                                    ..._maybeAddAverages(
                                      normal:
                                          term
                                              .statistics!
                                              .cumulativeWeightedAverage,
                                      pass:
                                          term
                                              .statistics!
                                              .cumulativeWeightedAveragePassed,
                                      normalLabel: 'Acumulado',
                                      passLabel: 'Acumulado (aprobatorio)',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                _buildStatisticsSection(
                                  context,
                                  title: 'Créditos',
                                  data: [
                                    ..._maybeAddCredits(
                                      normal:
                                          term
                                              .statistics!
                                              .mandatoryCreditsTaken,
                                      pass:
                                          term
                                              .statistics!
                                              .mandatoryCreditsPassed,
                                      normalLabel: 'Obligatorios',
                                      passLabel: 'Obligatorios (aprobados)',
                                    ),
                                    ..._maybeAddCredits(
                                      normal:
                                          term.statistics!.electiveCreditsTaken,
                                      pass:
                                          term
                                              .statistics!
                                              .electiveCreditsPassed,
                                      normalLabel: 'Electivos',
                                      passLabel: 'Electivos (aprobados)',
                                    ),
                                    if (term
                                            .statistics!
                                            .mandatoryCreditsValidated >
                                        0)
                                      [
                                        'Obligatorios convalidados',
                                        term
                                            .statistics!
                                            .mandatoryCreditsValidated
                                            .toString(),
                                      ],
                                    if (term
                                            .statistics!
                                            .electiveCreditsValidated >
                                        0)
                                      [
                                        'Electivos convalidados',
                                        term
                                            .statistics!
                                            .electiveCreditsValidated
                                            .toString(),
                                      ],
                                    if (term
                                            .statistics!
                                            .totalMandatoryCreditsValidated >
                                        0)
                                      [
                                        'Total obligatorios convalidados',
                                        term
                                            .statistics!
                                            .totalMandatoryCreditsValidated
                                            .toString(),
                                      ],
                                    ..._maybeAddCredits(
                                      normal:
                                          term
                                              .statistics!
                                              .totalMandatoryCreditsTaken,
                                      pass:
                                          term
                                              .statistics!
                                              .totalMandatoryCreditsPassed,
                                      normalLabel: 'Total obligatorios',
                                      passLabel:
                                          'Total obligatorios (aprobados)',
                                      total: report.curriculumMandatoryCredits,
                                    ),
                                    ..._maybeAddCredits(
                                      normal:
                                          term
                                              .statistics!
                                              .totalElectiveCreditsTaken,
                                      pass:
                                          term
                                              .statistics!
                                              .totalElectiveCreditsPassed,
                                      normalLabel: 'Total electivos',
                                      passLabel: 'Total electivos (aprobados)',
                                      total: report.curriculumElectiveCredits,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ...term.courses.map((course) {
                return ListTile(
                  title: Text('${course.courseName} (${course.courseCode})'),
                  subtitle: CourseSubtitleWidget(
                    children: [
                      CourseSubtitleWidgetItem(
                        icon:
                            course.courseType == CourseType.mandatory
                                ? MdiIcons.school
                                : MdiIcons.leaf,
                        text:
                            course.courseType == CourseType.mandatory
                                ? 'Obligatorio'
                                : 'Electivo',
                      ),
                      CourseSubtitleWidgetItem(
                        text:
                            course.credits == 1
                                ? '1 crédito'
                                : '${course.credits} créditos',
                      ),
                      if (course.programCurriculumCourse != null)
                        CourseSubtitleWidgetItem(
                          icon: Icons.book,
                          text:
                              'Ciclo ${course.programCurriculumCourse!.info.termRomanNumeral}',
                        ),
                    ],
                  ),
                  trailing: Text(
                    course.grade.toStringAsFixed(2),
                    style: TextStyle(
                      color: course.isApproved ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }),
            ],
          );
        }),
        if (academicHistory.length > 1)
          GradesPerCourseCategoryChart(academicHistory: academicHistory),
      ],
    );
  }

  Widget _buildStatisticsSection(
    BuildContext context, {
    required String title,
    required List<List<String>> data,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        ...data.map(
          (entry) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(entry[0]), SizedBox(width: 8), Text(entry[1])],
          ),
        ),
      ],
    );
  }

  /// This method is used to generate the statistics section of the career page.
  List<List<String>> _maybeAddAverages({
    required double normal,
    required double pass,
    required String normalLabel,
    required String passLabel,
  }) {
    final normalFixed = double.parse(normal.toStringAsFixed(2));
    final passFixed = double.parse(pass.toStringAsFixed(2));

    if (normalFixed == passFixed) {
      return [
        [normalLabel, normal.toStringAsFixed(2)],
      ];
    } else {
      return [
        [normalLabel, normal.toStringAsFixed(2)],
        [passLabel, pass.toStringAsFixed(2)],
      ];
    }
  }

  /// This method is used to generate the statistics section of the career page.
  List<List<String>> _maybeAddCredits({
    required int normal,
    required int pass,
    required String normalLabel,
    required String passLabel,
    int? total,
  }) {
    final totalLabel = total != null ? ' de $total' : '';
    if (normal == pass) {
      return [
        [normalLabel, '$normal$totalLabel'],
      ];
    } else {
      return [
        [normalLabel, '$normal$totalLabel'],
        [passLabel, '$pass$totalLabel'],
      ];
    }
  }
}
