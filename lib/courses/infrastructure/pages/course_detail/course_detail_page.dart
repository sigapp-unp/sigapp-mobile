import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/loading_indicator_icon.dart';
import 'package:sigapp/core/infrastructure/utils/time_utils.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/course_detail_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/course_avatar.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/schedule_section.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/components/table_info.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPageWidget extends StatefulWidget {
  const CourseDetailPageWidget({super.key, required this.color});

  final Color color;

  @override
  State<CourseDetailPageWidget> createState() => _CourseDetailPageWidgetState();
}

class _CourseDetailPageWidgetState extends State<CourseDetailPageWidget> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CourseDetailCubit>(context);
    return BlocConsumer<CourseDetailCubit, CourseDetailState>(
      builder: (context, state) {
        return switch (state) {
          CourseDetailEmptyState() => Container(),
          CourseDetailReadyState() => _build(state, context, cubit),
        };
      },
      listener: (context, state) {},
    );
  }

  Widget _build(
    CourseDetailReadyState state,
    BuildContext context,
    CourseDetailCubit cubit,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle')),
      // backgroundColor: Theme.of(context).colorScheme.,
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 16),
            child: CourseAvatarWidget(
              courseName: state.course.data.courseName,
              color: widget.color,
              diameter: MediaQuery.of(context).size.width * 0.25,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Text(
              state.course.data.courseName,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          ListTile(
            subtitle: TableInfoWidget([
              ['Código', state.course.data.courseCode],
              [
                'Tipo',
                state.course.data.courseType == CourseType.mandatory
                    ? 'Obligatorio'
                    : 'Electivo',
              ],
              ['Créditos', state.course.data.credits.toString()],
              ['Docente', state.course.data.professor],
              ['Fecha', TimeUtils.formatDate(state.course.data.date)],
            ]),
          ),
          if (state.course.data.url.trim().isNotEmpty)
            ListTile(
              title: Text('Abrir enlace'),
              trailing: Icon(Icons.open_in_browser),
              onTap: () {
                launchUrl(
                  Uri.parse(state.course.data.url),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          if (state.course.data.googleClassroomCode != null)
            ListTile(
              title: Text('Código Classroom'),
              subtitle: Text(state.course.data.googleClassroomCode!),
              trailing: Icon(Icons.copy),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: state.course.data.googleClassroomCode!),
                );
              },
            ),
          GestureDetector(
            onTapDown: (details) {
              // Guarda la posición a del toque.
              _tapPosition = details.globalPosition;
            },
            onLongPress: () {
              switch (state.syllabus) {
                case CourseDetailSyllabusStateLoaded():
                  _showPopupMenu(context, cubit, _tapPosition);
                default:
                  break;
              }
            },
            child: ListTile(
              title: Text('Syllabus'),
              subtitle: switch (state.syllabus) {
                CourseDetailSyllabusStateInitial() => Text('-'),
                CourseDetailSyllabusStateLoading() => Text('Cargando'),
                CourseDetailSyllabusStateLoaded() => Text('Disponible'),
                CourseDetailSyllabusStateNotFound() => Text('No disponible'),
                CourseDetailSyllabusStateError() => Text('Error al descargar'),
              },
              trailing: switch (state.syllabus) {
                CourseDetailSyllabusStateLoading() =>
                  LoadingIndicatorIconWidget(),
                CourseDetailSyllabusStateLoaded() => Icon(Icons.open_in_new),
                CourseDetailSyllabusStateNotFound() => Icon(Icons.refresh),
                CourseDetailSyllabusStateError() => Icon(Icons.info),
                _ => null,
              },
              onTap: () {
                switch (state.syllabus) {
                  case CourseDetailSyllabusStateLoaded(
                    syllabusFile: final file,
                  ):
                    OpenFile.open(file.path);
                  case CourseDetailSyllabusStateNotFound():
                    cubit.fetchSyllabus(forceDownload: true);
                  case CourseDetailSyllabusStateError():
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Reintentando')));
                    cubit.fetchSyllabus(forceDownload: true);
                  default:
                    break;
                }
              },
            ),
          ),
          ListTile(
            title: Text('Notas'),
            subtitle: switch (state.grades) {
              CourseDetailGradesStateInitial() => Text('-'),
              CourseDetailGradesStateLoading() => Text('Cargando'),
              CourseDetailGradesStateLoaded(value: final gradeInfo) =>
                switch (gradeInfo.grade) {
                  CourseGradePreviewLoaded(value: final grade) => Text(
                    '${grade.isPartial ? 'Nota parcial' : 'Nota final'}: ${grade.value.toStringAsFixed(2)}',
                  ),
                  CourseGradePreviewEmpty() => Text('No disponibles'),
                  _ => Text('No disponibles'),
                },
              CourseDetailGradesStateError() => Text('Error al obtener notas'),
            },
            trailing: switch (state.grades) {
              CourseDetailGradesStateLoading() => LoadingIndicatorIconWidget(),
              CourseDetailGradesStateLoaded() => Icon(Icons.open_in_new),
              CourseDetailGradesStateError() => Icon(Icons.info),
              _ => null,
            },
            onTap: () {
              switch (state.grades) {
                case CourseDetailGradesStateLoaded(value: final gradeInfo):
                  launchUrl(
                    Uri.parse(gradeInfo.url),
                    mode: LaunchMode.externalApplication,
                  );
                  switch (gradeInfo.grade) {
                    case CourseGradePreviewEmpty():
                      cubit.fetchGrades();
                    default:
                      break;
                  }
                case CourseDetailGradesStateError():
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Reintentando')));
                  cubit.fetchGrades();
                default:
                  break;
              }
            },
          ),
          Divider(),
          ScheduleSectionWidget(enrolledCourse: state.course),
          Divider(),
          BlocProvider(
            create: (context) => getIt<GradeTrackerSectionCubit>(),
            child: GradeTrackerSectionWidget(enrolledCourse: state.course),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _showPopupMenu(
    BuildContext context,
    CourseDetailCubit cubit,
    Offset tapPosition,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text('Refrescar'),
          onTap: () {
            cubit.fetchSyllabus(forceDownload: true);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Refrescando syllabus')));
          },
        ),
      ],
    );
  }
}
