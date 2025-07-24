import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/courses/domain/entities/academic_history_term.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/shared/domain/value_objects/scheduled_term_identifier.dart';
import 'package:sigapp/courses/domain/repositories/program_curriculum_repository.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';
import 'package:sigapp/courses/infrastructure/models/get_academic_history_term.dart';
import 'package:sigapp/courses/infrastructure/models/get_program_curriculum_course.dart';
import 'package:html/parser.dart' as htmlParser;

@LazySingleton(as: ProgramCurriculumRepository)
class ProgramCurriculumRepositoryImpl implements ProgramCurriculumRepository {
  final SigaClient _sigaClient;

  ProgramCurriculumRepositoryImpl(this._sigaClient);

  /// Node.js request equivalent:
  ///
  /// ```js
  /// fetch("https://academico.unp.edu.pe/Academico/ListarPlanDeEstudios", {
  ///   "headers": {
  ///     "accept": "application/json, text/javascript, */*; q=0.01",
  ///     "accept-language": "en-PE,en;q=0.6",
  ///     "priority": "u=1, i",
  ///     "sec-ch-ua": "\"Chromium\";v=\"134\", \"Not:A-Brand\";v=\"24\", \"Brave\";v=\"134\"",
  ///     "sec-ch-ua-mobile": "?0",
  ///     "sec-ch-ua-platform": "\"Windows\"",
  ///     "sec-fetch-dest": "empty",
  ///     "sec-fetch-mode": "cors",
  ///     "sec-fetch-site": "same-origin",
  ///     "sec-gpc": "1",
  ///     "x-requested-with": "XMLHttpRequest",
  ///     "cookie": "ASP.NET_SessionId=kgw0t4ahbanj3q2bwpyauhzz; .ASPXAUTH=9299A2B6A1E3400FBC27DB2A761543A3F54EC61718EDA6EC66991AD62147A1937CF645125E5C2EC4644B0B03E5A1846234A0464F0043DA2D8DF4423AF964CA4C554F20779030B187B97137E4B47E874DA66FDCA033D9CA59C45E969BA7732063B28356794286BFE16B93A37B5BDC074B57F81D3F0836B179441DC7D89ACEA2012BB68BEEF84A0F62144B457C24D036F020AEAC8BFFEA3E7DBE8F5DAA633E2816524526669210199FFA37E15D19001A66E671ED429CFF30E6C873DECD4D5D1F675A15CBF7DBC5CE1ECD97947AA943C3EF",
  ///     "Referer": "https://academico.unp.edu.pe/Academico/PlanDeEstudios",
  ///     "Referrer-Policy": "strict-origin-when-cross-origin"
  ///   },
  ///   "body": null,
  ///   "method": "POST"
  /// });
  /// ```
  ///
  /// Response:
  /// ```ts
  /// export type Root = {
  ///   results: Array<{
  ///     ExtensionData: {}
  ///     Ciclo: string
  ///     CodCurso: string
  ///     Creditos: number
  ///     DescripCurso: string
  ///     FlagTipoCurso: string
  ///     HorasPractica: number
  ///     HorasTeoria: number
  ///     NroCiclo: number
  ///     ResumenRequisitos: string
  ///   }>
  ///   total: number
  /// }
  /// ```
  @override
  Future<List<ProgramCurriculumCourseInfo>> getProgramCurriculum() async {
    final response = await _sigaClient.http.post(
      '/Academico/ListarPlanDeEstudios',
      data: null,
    );
    final models =
        (response.data['results'] as List)
            .map((json) => GetProgramCurriculumCourseModel.fromJson(json))
            .toList();
    final entities =
        models
            .map(
              (model) => ProgramCurriculumCourseInfo(
                courseCode: model.CodCurso,
                credits: model.Creditos,
                courseName: model.DescripCurso,
                courseType: CourseType.fromValue(model.FlagTipoCurso),
                practiceHours: model.HorasPractica,
                theoryHours: model.HorasTeoria,
                termNumber: model.NroCiclo,
                requirementCourseCodes:
                    model.ResumenRequisitos == '---'
                        ? []
                        : model.ResumenRequisitos.split(' - ').toList(),
              ),
            )
            .toList();

    return entities;
  }

  @override
  Future<List<AcademicHistoryTerm>> getAcademicHistory() async {
    // Fetch
    final response = await _sigaClient.http.get(
      '/Academico/HistorialAcademico',
    );
    final pageSource = response.data as String;
    final html = htmlParser.parse(pageSource);

    // Build
    final termLabels =
        html
            .querySelectorAll('h4')
            .map((e) => e.text.trim().split(' ').last)
            .toList();
    final rawTerms = html.querySelectorAll('.k-grid.k-widget');
    if (termLabels.length != rawTerms.length) {
      throw Exception('Term labels and terms mismatch');
    }
    final terms =
        rawTerms.asMap().entries.map((entry) {
          final index = entry.key;
          final element = entry.value;
          final tables = element.querySelectorAll('table');
          List<List<String>>? creditsAndGPAData =
              tables.first
                  .querySelectorAll('tr')
                  .map(
                    (e) =>
                        e
                            .querySelectorAll('td')
                            .map((e) => e.text.trim())
                            .toList(),
                  )
                  .toList();
          if (creditsAndGPAData.isEmpty || creditsAndGPAData[0].isEmpty) {
            creditsAndGPAData = null;
          }
          final coursesData =
              tables.last
                  .querySelectorAll('tbody tr')
                  .map(
                    (tr) =>
                        tr
                            .querySelectorAll('td')
                            .map((e) => e.text.trim())
                            .toList(),
                  )
                  .toList();
          return {
            'termLabel': termLabels[index],
            'statistics':
                creditsAndGPAData != null
                    ? {
                      'PPS': double.parse(creditsAndGPAData[0][1]),
                      'PPSAprob': double.parse(creditsAndGPAData[0][3]),
                      'PPA': double.parse(creditsAndGPAData[0][5]),
                      'PPAApr': double.parse(creditsAndGPAData[0][7]),
                      'CreOblLlev': double.parse(creditsAndGPAData[0][9]),
                      'CreElLlev': double.parse(creditsAndGPAData[1][1]),
                      'CreOblApr': double.parse(creditsAndGPAData[1][3]),
                      'CreEleApr': double.parse(creditsAndGPAData[1][5]),
                      'CreOblConv': double.parse(creditsAndGPAData[1][7]),
                      'CredEleConv': double.parse(creditsAndGPAData[1][9]),
                      'TotalCredOblLlev': double.parse(creditsAndGPAData[2][1]),
                      'TotalCredElLlev': double.parse(creditsAndGPAData[2][3]),
                      'TotalCredOblAprob': double.parse(
                        creditsAndGPAData[2][5],
                      ),
                      'TotalCredElAprob': double.parse(creditsAndGPAData[2][7]),
                      'TotalCredOblConv': double.parse(creditsAndGPAData[2][9]),
                    }
                    : null,
            'courses':
                coursesData
                    .map(
                      (tds) => {
                        'courseCode': tds[0],
                        'courseName': tds[1],
                        'courseType': tds[2],
                        'credits': int.parse(tds[3]),
                        'grade': double.parse(tds[4]),
                      },
                    )
                    .toList(),
          };
        }).toList();
    final models =
        terms
            .map((term) => GetAcademicHistoryTermModel.fromJson(term))
            .toList();

    // Parse
    final entities =
        models
            .map(
              (model) => AcademicHistoryTerm(
                term: ScheduledTermIdentifier.buildFromName(model.termLabel),
                statistics:
                    model.statistics != null
                        ? AcademicHistoryTermStatistics(
                          termWeightedAverage: model.statistics!.PPS,
                          termWeightedAveragePassed: model.statistics!.PPSAprob,
                          cumulativeWeightedAverage: model.statistics!.PPA,
                          cumulativeWeightedAveragePassed:
                              model.statistics!.PPAApr,
                          mandatoryCreditsTaken:
                              model.statistics!.CreOblLlev.toInt(),
                          electiveCreditsTaken:
                              model.statistics!.CreElLlev.toInt(),
                          mandatoryCreditsPassed:
                              model.statistics!.CreOblApr.toInt(),
                          electiveCreditsPassed:
                              model.statistics!.CreEleApr.toInt(),
                          mandatoryCreditsValidated:
                              model.statistics!.CreOblConv.toInt(),
                          electiveCreditsValidated:
                              model.statistics!.CredEleConv.toInt(),
                          totalMandatoryCreditsTaken:
                              model.statistics!.TotalCredOblLlev.toInt(),
                          totalElectiveCreditsTaken:
                              model.statistics!.TotalCredElLlev.toInt(),
                          totalMandatoryCreditsPassed:
                              model.statistics!.TotalCredOblAprob.toInt(),
                          totalElectiveCreditsPassed:
                              model.statistics!.TotalCredElAprob.toInt(),
                          totalMandatoryCreditsValidated:
                              model.statistics!.TotalCredOblConv.toInt(),
                        )
                        : null,
                courses:
                    model.courses
                        .map(
                          (course) => AcademicHistoryCourse(
                            courseCode: course.courseCode,
                            courseName: course.courseName,
                            courseType: CourseType.fromValue(course.courseType),
                            credits: course.credits,
                            grade: course.grade,
                          ),
                        )
                        .toList(),
              ),
            )
            .toList();

    return entities;
  }
}
