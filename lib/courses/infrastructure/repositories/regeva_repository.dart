import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/regeva_client.dart';
import 'package:sigapp/courses/application/exceptions/regeva_authentication_exception.dart';
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart';
import 'package:sigapp/courses/domain/value-objects/course_grade.dart';
import 'package:sigapp/courses/domain/value-objects/syllabus_download_data.dart';
import 'package:html/parser.dart' as htmlParser;

@LazySingleton(as: RegevaRepository)
class RegevaRepositoryImpl implements RegevaRepository {
  final RegevaClient _regevaClient;

  RegevaRepositoryImpl(this._regevaClient);

  @override
  String buildGradesUrl({
    required String scheduledCourseId,
    required String token1,
    required String token2,
    required String studentCode,
  }) {
    return '${RegevaClient.url}/Home/Token'
        '?cu=$studentCode-01-PI'
        '&token1=$token1'
        '&token2=$token2'
        '&ip=$scheduledCourseId';
  }

  /// Necessary to download Regeva files
  @override
  Future<void> authenticate({
    required String sigaToken1,
    required String sigaToken2,
    required String studentCode,
  }) async {
    final response = await _regevaClient.http.get(
      buildGradesUrl(
        scheduledCourseId: 'P212050089', // dummy value
        token1: sigaToken1,
        token2: sigaToken2,
        studentCode: studentCode,
      ),
      options: Options(
        validateStatus: (status) => true,
        followRedirects: false,
      ),
    );

    _ensureRedirectionSuccess(response);

    final setCookieHeaders = response.headers['set-cookie'] ?? [];
    if (setCookieHeaders.isEmpty) {
      throw RegevaAuthenticationException(
        'No set-cookie headers found, authentication failed',
      );
    }

    return;
  }

  void _ensureRedirectionSuccess(Response<dynamic> response) {
    final locationHeaders = response.headers['location'] ?? [];
    if (response.statusCode == 302 &&
        !locationHeaders.any(
          (value) =>
              value.startsWith(RegevaClient.successCourseRedirectionLocation),
        )) {
      throw RegevaAuthenticationException(
        'Redirection indicates authentication failure',
      );
    }
  }

  // Node.js request equivalent:
  // fetch("http://regeva.unp.edu.pe:8081/Cursos/Silabo/P212050089", {
  //   "headers": {
  //     "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
  //     "accept-language": "en-PE,en;q=0.9",
  //     "sec-gpc": "1",
  //     "upgrade-insecure-requests": "1",
  //     "cookie": "__RequestVerificationToken=YiLc6uXBStsyzqFoykgXHmyu5JWWqri5ghawjWeWBTVwJ5a3AaE-PANFK3rzyoA3pciMlwDJlOehfT_zHg7m33mmbN8wEagAlYEaot_TOCfxjh4zYcDo1rW7ZXLsAYtXjTQgdQ1uF0QK1ebBSnBtow2; .ASPXAUTH=ED65E192024F0E4ECB6D521FD1158701B9F0741630984012F7BC2411E9A63B013C888633D43DD8B423AF36B1FD08F0502F117B46450EDD47B59E28D1256F6CB43537BE35049E6F1F0396C860CBC60849C2FC1D62D65848ED354B235679514C61E49AC5167D78F3F9008A2AF87C79873F2308D38D58028DF5743ACEC199398C4C5728C110DE4997336161C841E7F6EEB0F492AF4702C150DF453E374C32225312611E311F7752556E5A839CCB21DA24458DF177208BF69880C5429F8AC8189BE3"
  //   },
  //   "referrerPolicy": "strict-origin-when-cross-origin",
  //   "body": null,
  //   "method": "GET"
  // });
  @override
  Future<SyllabusDownloadData?> downloadSyllabus(
    String scheduledCourseId,
  ) async {
    final response = await _regevaClient.http.get(
      'http://regeva.unp.edu.pe:8081/Cursos/Silabo/$scheduledCourseId',
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => true,
        followRedirects: false,
      ),
    );

    // Verify authentication error
    _ensureSignOutNotTriggered(response);

    if (response.statusCode != 200) return null;

    // Extract filename from Content-Disposition header
    final contentType = response.headers['content-type']?.first;
    final data = Uint8List.fromList(response.data);

    return SyllabusDownloadData(contentType: contentType, data: data);
  }

  void _ensureSignOutNotTriggered(Response<dynamic> response) {
    final locationHeaders = response.headers['location'] ?? [];
    if (response.statusCode == 302 &&
        locationHeaders.any(
          (value) =>
              value.startsWith(RegevaClient.forceSignOutRedirectionLocation),
        )) {
      throw RegevaAuthenticationException('Regeva authentication failed');
    }
  }

  @override
  Future<void> disposeCookies() async {
    await _regevaClient.cookieManager.clearAllCookies();
  }

  @override
  Future<CourseGradeValue?> getCourseGrade({
    required String scheduledCourseId,
    required String studentCode,
    required String sigaToken1,
    required String sigaToken2,
  }) async {
    // Get
    final response = await _regevaClient.http.get(
      buildGradesUrl(
        scheduledCourseId: scheduledCourseId,
        token1: sigaToken1,
        token2: sigaToken2,
        studentCode: studentCode,
      ),
      options: Options(maxRedirects: 1),
    );

    // Build
    final html = htmlParser.parse(response.data as String);

    // ```html
    // ...
    // <div class="center alert alert-info bolder">
    //     <span class="badge badge-success">Aprobado</span>
    //     <div>
    //         Nota Final
    //         <span class="badge badge-success">14</span>
    //     </div>
    // </div>
    // ...
    // ```
    final container = html.querySelector('.bolder > div');
    if (container == null) return null;
    final text = container.text.trim();
    final gradeText = RegExp(r'(\d+(\.\d+)?)').firstMatch(text)?.group(1);
    if (gradeText == null) return null;
    final isFinal = text.toLowerCase().contains('final');

    return CourseGradeValue(
      value: double.parse(gradeText),
      isPartial: !isFinal,
    );
  }
}
