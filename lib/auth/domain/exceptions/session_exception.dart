sealed class SessionException implements Exception {
  const SessionException({required this.message, required this.originalError});

  final String message;
  final dynamic originalError;

  // const factory SessionException.networkError({
  //   required dynamic originalError,
  // }) = NetworkSessionException;

  const factory SessionException.refreshError({
    required dynamic originalError,
  }) = RefreshSessionException;

  const factory SessionException.authenticationError({
    required dynamic originalError,
  }) = AuthenticationSessionException;

  const factory SessionException.studentInfoError({
    required dynamic originalError,
  }) = StudentInfoSessionException;

  const factory SessionException.pendingSurveyError({
    required dynamic originalError,
  }) = PendingSurveySessionException;

  const factory SessionException.unknownError({
    required dynamic originalError,
  }) = UnknownSessionException;

  @override
  String toString() =>
      'SessionException(message: $message, originalError: $originalError)';
}

// class NetworkSessionException extends SessionException {
//   const NetworkSessionException({required super.originalError})
//     : super(
//         message:
//             'Se cerró tu sesión debido a problemas de conexión. Por favor, verifica tu conexión a internet y vuelve a intentarlo.',
//       );

//   @override
//   String toString() =>
//       'NetworkSessionException(message: $message, originalError: $originalError)';
// }

class RefreshSessionException extends SessionException {
  const RefreshSessionException({required super.originalError})
    : super(
        message:
            'Tu sesión ha expirado. Esto puede ocurrir por inactividad o problemas en el servidor. Por favor, inicia sesión nuevamente.',
      );

  @override
  String toString() =>
      'RefreshSessionException(message: $message, originalError: $originalError)';
}

class AuthenticationSessionException extends SessionException {
  const AuthenticationSessionException({required super.originalError})
    : super(
        message:
            'Se ha cerrado tu sesión por motivos de seguridad. Por favor, inicia sesión nuevamente.',
      );

  @override
  String toString() =>
      'AuthenticationSessionException(message: $message, originalError: $originalError)';
}

class StudentInfoSessionException extends SessionException {
  const StudentInfoSessionException({required super.originalError})
    : super(
        message:
            'No se pudo verificar tu información académica. Por favor, intenta nuevamente más tarde.',
      );

  @override
  String toString() =>
      'StudentInfoSessionException(message: $message, originalError: $originalError)';
}

class PendingSurveySessionException extends SessionException {
  const PendingSurveySessionException({required super.originalError})
    : super(
        message:
            'Tienes encuestas pendientes que deben ser completadas en la versión web de SIGA. Por favor, inicia sesión en la plataforma web para completarlas.',
      );

  @override
  String toString() =>
      'PendingSurveySessionException(message: $message, originalError: $originalError)';
}

class UnknownSessionException extends SessionException {
  const UnknownSessionException({required super.originalError})
    : super(
        message:
            'Se cerró tu sesión por un error desconocido. Por favor, inicia sesión nuevamente.',
      );

  @override
  String toString() =>
      'UnknownSessionException(message: $message, originalError: $originalError)';
}
