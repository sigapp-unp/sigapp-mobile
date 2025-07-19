import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';
import 'package:sigapp/courses/infrastructure/pages/career/widgets/course_subtitle.dart';
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/course_prerequisite_chain_page.dart';
import 'package:sigapp/shared/infrastructure/utils/logo_file_utils.dart';
import 'package:sigapp/student/domain/entities/student_academic_report.dart';

class CareerPageProgramCurriculumWidget extends StatefulWidget {
  const CareerPageProgramCurriculumWidget({
    super.key,
    required this.programCurriculum,
    required this.academicReport,
  });

  final List<ProgramCurriculumTerm> programCurriculum;
  final AcademicReport academicReport;

  @override
  State<CareerPageProgramCurriculumWidget> createState() =>
      _CareerPageProgramCurriculumWidgetState();
}

class _CareerPageProgramCurriculumWidgetState
    extends State<CareerPageProgramCurriculumWidget> {
  late int? _lastEnrolledTermIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _findLastEnrolledTerm();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToLastEnrolled(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _findLastEnrolledTerm() {
    _lastEnrolledTermIndex = null;
    for (int i = widget.programCurriculum.length - 1; i >= 0; i--) {
      if (widget.programCurriculum[i].courses.any(
        (course) => course.isEnrolled == true,
      )) {
        _lastEnrolledTermIndex = i;
        break;
      }
    }
  }

  void _scrollToLastEnrolled() {
    if (_lastEnrolledTermIndex != null) {
      final double estimatedPosition = _lastEnrolledTermIndex! * 56.0;
      _scrollController.animateTo(
        estimatedPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final faculty = widget.academicReport.faculty;

    return Stack(
      children: [
        if (faculty != null)
          Positioned(
            bottom: -size.height * 0.0,
            left: -size.height * 0.0,
            child: Opacity(
              opacity: 0.08,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isDarkTheme ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                child: Image.asset(
                  getFacultyImagePath(faculty),
                  fit: BoxFit.cover,
                  height: size.height * 0.85,
                ),
              ),
            ),
          ),
        ListView(
          controller: _scrollController,
          children:
              widget.programCurriculum
                  .asMap()
                  .map((index, term) {
                    return MapEntry(
                      index,
                      ExpansionTile(
                        initiallyExpanded: index == _lastEnrolledTermIndex,
                        title: Row(
                          children: [
                            Icon(Icons.book),
                            SizedBox(width: 8),
                            Text(
                              'Ciclo ${term.termRomanNumeral}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        children:
                            term.courses.map((course) {
                              return _buildItem(
                                context,
                                course: course,
                                onSeePrerequisites: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              CoursePrerequisiteChainPage(
                                                course: course,
                                                programCurriculum:
                                                    widget.programCurriculum,
                                              ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    );
                  })
                  .values
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required ProgramCurriculumCourse course,
    required VoidCallback onSeePrerequisites,
  }) {
    final items = <CourseSubtitleWidgetItem>[];
    items.add(
      CourseSubtitleWidgetItem(
        icon:
            course.info.courseType == CourseType.mandatory
                ? MdiIcons.school
                : MdiIcons.leaf,
        text:
            course.info.courseType == CourseType.mandatory
                ? 'Obligatorio'
                : 'Electivo',
      ),
    );
    items.add(
      CourseSubtitleWidgetItem(
        text:
            course.info.credits == 1
                ? '1 crédito'
                : '${course.info.credits} créditos',
      ),
    );
    if (course.prerequisites.isNotEmpty) {
      items.add(
        CourseSubtitleWidgetItem(
          icon: MdiIcons.link,
          text:
              '${course.prerequisites.length} requisito${course.prerequisites.length != 1 ? 's' : ''}',
        ),
      );
    } else if (course.info.termNumber != 1) {
      items.add(
        CourseSubtitleWidgetItem(
          icon: MdiIcons.linkOff,
          text: 'Sin requisitos',
        ),
      );
    }
    if (course.isEnrolled == true) {
      items.add(CourseSubtitleWidgetItem(icon: Icons.check, text: 'Inscrito'));
    }

    return ListTile(
      leading:
          (() {
            if (course.isApproved == true) {
              return const Icon(Icons.check, color: Colors.green);
            }
            if (course.isApproved == false) {
              return const Icon(Icons.close, color: Colors.red);
            }
            if (course.hasPrerequisitesApproved == null) {
              return Icon(Icons.abc, color: Colors.transparent);
            }
            if (course.isEnrolled == true) {
              return Icon(
                MdiIcons.progressClock,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            if (course.hasPrerequisitesApproved == true) {
              return Icon(
                Icons.lock_open_outlined,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return Icon(Icons.lock_outlined);
          })(),
      title: Text('${course.info.courseName} (${course.info.courseCode})'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CourseSubtitleWidget(children: items),
          if (course.prerequisites.isNotEmpty ||
              course.getDependentCoursesTree(
                    programCurriculum: widget.programCurriculum,
                  ) !=
                  null)
            TextButton.icon(
              icon: Icon(Icons.link),
              label: Text('Ver cadena de requisitos'),
              onPressed: onSeePrerequisites,
            ),
        ],
      ),
    );
  }
}
