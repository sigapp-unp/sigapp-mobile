import 'package:sigapp/auth/domain/exceptions/session_exception.dart';
import 'package:sigapp/auth/domain/value-objects/api_path_and_method.dart';
// import 'package:sigapp/auth/domain/value-objects/api_response.dart';

abstract class SessionLifecycleService {
  /// Sets up the logic to refresh the session before requests (unless excluded)
  /// and to detect session expiration after responses.
  void configureSessionInterceptors({
    required Future<void> Function() awaitOngoingSessionRefresh,
    required List<ApiPathAndMethod> endpointsExcludedFromPreRequestRefresh,
    required void Function(SessionException? technicalReason) onSessionExpired,
  });

  // void configureSurveyAssertionInterceptors({
  //   required Future<void> Function(ApiResponse response) ensureNoPendingSurvey,
  // });
  // bool evaluateIsSurveyAvailable(ApiResponse response);
  bool checkLoginResult({
    required Map<String, List<String>> headers,
    required int statusCode,
  });
}
