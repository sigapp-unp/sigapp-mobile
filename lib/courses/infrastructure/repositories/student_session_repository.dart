import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/courses/application/value-objects/student_session_info.dart';
import 'package:sigapp/courses/application/repositories/student_session_repository.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:sigapp/courses/domain/entities/scheduled_term_identifier.dart';

@LazySingleton(as: StudentSessionRepository)
class StudentSessionRepositoryImpl implements StudentSessionRepository {
  final SigaClient _sigaClient;
  StudentSessionInfo? _cachedStudentSessionInfo;

  StudentSessionRepositoryImpl(this._sigaClient);

  @override
  Future<StudentSessionInfo> getStudentSessionInfo({bool? forceRefresh}) async {
    if (_cachedStudentSessionInfo != null && forceRefresh != true) {
      return _cachedStudentSessionInfo!;
    }

    final response1 = await _sigaClient.http.get('/Academico/Boletin');
    final pageSource = response1.data as String;

    // Get regeva tokens
    final regex = RegExp(r'token1=(.*?)&amp;token2=(.*?)&amp;ip=');
    final match = regex.firstMatch(pageSource);

    if (match == null) {
      throw Exception('Regeva tokens not found');
    }
    final regevaToken1 = match.group(1);
    if (regevaToken1 == null) throw Exception('Token1 not found');
    final regevaToken2 = match.group(2);
    if (regevaToken2 == null) throw Exception('Token2 not found');

    // Get student code, school name and current semester
    final html = htmlParser.parse(pageSource);
    final parts =
        html.querySelectorAll('dd').map((e) => e.text.trim()).toList();
    final studentCode = parts[0].split(' - ')[0];
    if (studentCode.isEmpty) throw Exception('Student code not found');
    final currentSemesterName = parts[3];
    final schoolName = parts[1];

    return StudentSessionInfo(
      studentCode: studentCode,
      schoolName: schoolName,
      currentSemester: ScheduledTermIdentifier.buildFromName(
        currentSemesterName,
      ),
      regevaToken1: regevaToken1,
      regevaToken2: regevaToken2,
    );
  }
}
