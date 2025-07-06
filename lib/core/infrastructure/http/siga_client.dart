import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigapp/core/infrastructure/http/http_client_builder.dart';
import 'package:sigapp/core/infrastructure/http/cookie_manager.dart';
import 'package:logger/logger.dart';

@singleton
class SigaClient {
  static const host = 'academico.unp.edu.pe';
  static const url = 'https://$host';
  static const forceSignOutRedirectionLocation = '/Cuenta/InicioSesion';
  static const successSignInRedirectionLocation = '/Home/Index';
  static const signInPath = '/';
  static const keepSessionPath = "/Home/KeepSession";
  static const survey1RedirectionLocation = "/PasosRequeridos/ProcesoEncuesta";
  static const survey2RedirectionLocation =
      "/PasosRequeridos/ProcesoDatosAlumno";
  late final HttpClientBuilderResult _httpClient;

  SigaClient(SharedPreferences prefs, Logger logger) {
    _httpClient =
        HttpClientBuilder(id: 'siga', prefs: prefs, logger: logger)
            .setBaseUrl(url)
            // .addHeader(
            //   'Accept',
            //   'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
            // )
            .addHeader('Accept-Language', 'es-PE,es;q=0.9,en;q=0.8')
            .addHeader('Cache-Control', 'no-cache')
            .addHeader('Pragma', 'no-cache')
            .addHeader('Sec-Fetch-Dest', 'document')
            .addHeader('Sec-Fetch-Mode', 'navigate')
            .addHeader('Sec-Fetch-Site', 'same-origin')
            .addHeader('Sec-Fetch-User', '?1')
            .addHeader('Upgrade-Insecure-Requests', '1')
            .addHeader(
              'User-Agent',
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
            )
            .addHeader('Origin', url)
            .addHeader('Referer', url)
            .build();
  }

  Dio get http => _httpClient.http;

  CookieManager get cookieManager => _httpClient.cookieManager;
}
