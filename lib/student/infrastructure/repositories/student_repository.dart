import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/student/domain/repositories/student_repository.dart';
import 'package:sigapp/student/domain/value_objects/raw_academic_report.dart';
import 'package:sigapp/student/infrastructure/models/get_academic_report.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final SigaClient _sigaClient;
  RawAcademicReport? _cachedAcademicReport;

  StudentRepositoryImpl(this._sigaClient);

  // @override
  // Future<StudentSessionInfo> getSessionStudentInfo() async {
  //   final response = await _sigaClient.http.get('/Home/Index');
  //   final rawHtml = response.data as String;
  //   final html = htmlParser.parse(rawHtml);
  //   final parts =
  //       html.querySelectorAll('dd').map((e) => e.text.trim()).toList();
  //   if (parts.length < 4) {
  //     // TODO: LOGOUT?
  //     throw Exception('Session info not found');
  //   }
  //   final currentSemesterId = parts[3];
  //   final schoolName = parts[1];
  //   return StudentSessionInfo(
  //     currentSemesterName: currentSemesterId,
  //     schoolName: schoolName,
  //   );
  // }

  @override
  Future<RawAcademicReport> getAcademicReport() async {
    if (_cachedAcademicReport != null) {
      return _cachedAcademicReport!;
    }

    // {"results":{"Facultad":"INGENIERIA INDUSTRIAL","NomAlumno":"0512017039 - CALLE BRICEÑO, JOSE DANIEL","Promocion":"2017","SemestreIngreso":"20171 ","SemestrePlan":"20181 ","UltSemestre":"20212 ","PPA":14.47,"PPAAprob":14.47,"UPPS":15.48,"TotalCredAprob":243,"CredObligPlan":220,"CredElectPlan":15,"CredObligAprob":220,"CredElectAprob":16}}
    final response = await _sigaClient.http.post(
      '/Academico/ListarParametrosInforme',
    );
    final model = GetAcademicReportModel.fromJson(response.data['results']);
    final academicReport = RawAcademicReport(
      faculty: model.Facultad,
      studentName: model.NomAlumno,
      cohort: model.Promocion,
      enrollmentSemesterId: model.SemestreIngreso,
      curriculumSemesterId: model.SemestrePlan,
      lastSemesterId: model.UltSemestre,
      cumulativeWeightedAverage: model.PPA,
      cumulativeWeightedAverageOfPassedCourses: model.PPAAprob,
      lastCumulativeWeightedAverage: model.UPPS,
      totalCreditsOfPassedCourses: model.TotalCredAprob,
      curriculumMandatoryCredits: model.CredObligPlan,
      curriculumElectiveCredits: model.CredElectPlan,
      mandatoryCreditsOfPassedCourses: model.CredObligAprob,
      electiveCreditsOfPassedCourses: model.CredElectAprob,
    );

    _cachedAcademicReport = academicReport;
    return academicReport;
  }

  @override
  void clearCache() {
    _cachedAcademicReport = null;
  }
}
