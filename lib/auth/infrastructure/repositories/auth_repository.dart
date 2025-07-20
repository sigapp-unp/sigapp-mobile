import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/domain/value-objects/api_path_and_method.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/auth/domain/repositories/auth_repository.dart';
import 'package:sigapp/auth/domain/value-objects/api_response.dart';
import 'package:html/parser.dart' as htmlParser;

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final SigaClient _sigaClient;
  final Logger _logger;

  AuthRepositoryImpl(this._sigaClient, this._logger);

  @override
  Future<ApiResponse> login(String username, String password) async {
    final response = await _sigaClient.http.post(
      SigaClient.signInPath,
      data: {
        'Instancia': '01',
        'CodAlumno': username,
        'ClaveWeb': password,
        'g-recaptcha-response': '',
      },
      options: Options(
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        followRedirects: false,
        validateStatus: (status) {
          return true;
        },
      ),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');

    final (
      String? messageLevel1,
      String? messageLevel2,
      String? messageLevel3,
    ) = (() {
          try {
            final html = htmlParser.parse(response.data);
            final container = html.querySelector(
              '.validation-summary-errors.text-danger',
            );
            if (container == null) return (null, null, null);
            // <form action="/" autocomplete="off" class="form-horizontal" method="post" role="form">				<div class="form-group form-group-sm">
            //                     <label for="CodAlumno" class="col-sm-12 control-label">
            // 					Realizar el proceso de cambio de Clave en su cuenta SIGA ACADEMICO(Recuerda que son 8 caracteres exactos combine letras y numeros para mayor seguridad), segun los procedimientos indicados. Evitar acceder desde aplicativos no oficiales.

            // 					</label>

            //                 </div>
            // 				<div class="form-group form-group-sm">
            // 				</div>
            // 				<div class="form-group form-group-sm">
            //                     <label for="Instancia" class="col-sm-4 control-label">Instancia:</label>
            //                     <div class="col-sm-8">

            //                         <select class="form-control" data-val="true" data-val-required="Seleccione una instancia" id="Instancia" name="Instancia"><option selected="selected" value="01">PREGRADO</option>
            // <option value="03">PROGRAMA DE EDUCACION</option>
            // </select>
            //                         <span class="help-block"></span>
            //                     </div>
            //                 </div>
            //                 <div class="form-group form-group-sm">
            //                     <label for="CodAlumno" class="col-sm-4 control-label">Código Alumno:</label>
            //                     <div class="col-sm-8">
            //                         <input class="form-control" data-val="true" data-val-required="El campo C&amp;#243;digo de Alumno es requerido" id="CodAlumno" maxlength="10" minlength="8" name="CodAlumno" placeholder="Ingrese su codigo de alumno" type="text" value="0512017039" spellcheck="false" data-ms-editor="true">
            //                         <span class="help-block"></span>
            //                     </div>
            //                 </div>
            //                 <div class="form-group form-group-sm">
            //                     <label for="ClaveWeb" class="col-sm-4 control-label">Clave Web:</label>
            //                     <div class="col-sm-8">
            //                         <input class="form-control" data-val="true" data-val-required="El campo Clave Web es requerido" id="ClaveWeb" name="ClaveWeb" placeholder="Su clave de acceso" type="password">
            //                         <span class="help-block">
            //                             <span class="text-primary hidden">La clave distingue mayúsculas de minúsculas.</span>
            //                         </span>
            //                         <span class="help-block"></span>
            //                     </div>
            //                 </div>
            // 				<div class="form-group form-group-sm">
            // 					<input type="text" name="honeypot" style="display:none;" tabindex="-1">
            // 				</div>
            //                 <div class="form-group form-group-sm">
            //                     <label for="recaptcha" class="col-sm-4 control-label">Código Captcha:</label>

            // 					<div class="col-sm-8">
            //                         <div class="g-recaptcha" data-sitekey="6LepXlwUAAAAAA5F-HxEqANVVylgtD3isyc_QN6b"><div style="width: 304px; height: 78px;"><div><iframe title="reCAPTCHA" width="304" height="78" role="presentation" name="a-k3d0i52ntq4" frameborder="0" scrolling="no" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-top-navigation allow-modals allow-popups-to-escape-sandbox allow-storage-access-by-user-activation" src="https://www.google.com/recaptcha/api2/anchor?ar=1&amp;k=6LepXlwUAAAAAA5F-HxEqANVVylgtD3isyc_QN6b&amp;co=aHR0cHM6Ly9hY2FkZW1pY28udW5wLmVkdS5wZTo0NDM.&amp;hl=en&amp;v=3jpV4E_UA9gZWYy11LtggjoU&amp;size=normal&amp;anchor-ms=20000&amp;execute-ms=15000&amp;cb=nwkodpf8maqk"></iframe></div><textarea id="g-recaptcha-response" name="g-recaptcha-response" class="g-recaptcha-response" style="width: 250px; height: 40px; border: 1px solid rgb(193, 193, 193); margin: 10px 25px; padding: 0px; resize: none; display: none;"></textarea></div><iframe style="display: none;"></iframe></div>
            //                         <span class="help-block"></span>
            //                         <span class="help-block">
            //                             <a href="/Cuenta/ResetPassword">¿Ha olvidado su clave de ingreso?</a>
            //                         </span>
            //                     </div>
            //                 </div>
            //                 <div class="form-group form-group-sm">
            //                     <div class="col-sm-offset-4 col-sm-8">
            //                         <button type="submit" class="btn-primary">Iniciar Sesión</button>
            //                     </div>
            //                 </div>
            // 				<div class="form-group form-group-sm">
            //                    <!-- <label class="col-sm-12 control-label"> Incripción 20211- Promoción 2016 y anteriores (10:00am  - 09:00pm)<br/> -->

            //                 </div>
            // </form>

            return (
              container.querySelector('li')?.text,
              container.querySelector('span')?.text,
              // Buscar el primer label que no sea para un campo específico de formulario
              (() {
                final labels = html.querySelectorAll('label.control-label');
                for (final label in labels) {
                  final text = label.text.trim();
                  // Si el texto es largo y no parece ser un label típico de campo
                  if (text.length > 50 && !_isTypicalFieldLabel(text)) {
                    return text;
                  }
                }
                return null;
              })(),
            );
          } catch (e, s) {
            _logger.e(
              'Error processing HTML at AuthRepositoryImpl.login',
              error: e,
              stackTrace: s,
            );
            return (null, null, null);
          }
        })();

    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
      messageLevel1: messageLevel1,
      messageLevel2: messageLevel2,
      messageLevel3: messageLevel3,
    );
  }

  @override
  Future<ApiResponse> keepSession() async {
    final response = await _sigaClient.http.post(
      SigaClient.keepSessionPath,
      options: Options(validateStatus: (status) => true),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');
    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
    );
  }

  @override
  Future<void> disposeCookies() async {
    await _sigaClient.cookieManager.clearAllCookies();
  }

  @override
  Future<ApiResponse> checkSurvey1() async {
    return _checkSurvey(SigaClient.survey1RedirectionLocation);
  }

  @override
  Future<ApiResponse> checkSurvey2() async {
    return _checkSurvey(SigaClient.survey2RedirectionLocation);
  }

  Future<ApiResponse> _checkSurvey(String path) async {
    final response = await _sigaClient.http.get(
      path,
      options: Options(validateStatus: (status) => true),
    );
    final statusCode = response.statusCode;
    if (statusCode == null) throw Exception('Status code is null');
    return ApiResponse(
      statusCode: statusCode,
      headers: response.headers.map,
      pathAndMethod: ApiPathAndMethod(
        ApiMethod.fromString(response.requestOptions.method),
        response.requestOptions.path,
      ),
    );
  }

  /// Helper method to determine if a label text is a typical field label
  /// vs an informational message
  bool _isTypicalFieldLabel(String text) {
    // Patterns that indicate a typical field label
    final fieldLabelPatterns = [
      'instancia:',
      'código',
      'clave',
      'captcha:',
      'usuario:',
      'contraseña:',
      'email:',
      'nombre:',
      'apellido:',
    ];

    final lowercaseText = text.toLowerCase();
    return fieldLabelPatterns.any(
      (pattern) => lowercaseText.contains(pattern) && text.length < 50,
    );
  }
}
