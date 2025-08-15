import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/auth/application/services/firebase_auth_service.dart';
import 'package:sigapp/auth/infrastructure/managers/firebase_custom_token_manager.dart';
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart';

@LazySingleton(as: FirebaseAuthService)
class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final ApiGatewayClient _client;
  final FirebaseCustomTokenManager _customTokenManager;
  final Logger _logger;

  FirebaseAuthServiceImpl(
    this._firebaseAuth,
    this._client,
    this._customTokenManager,
    this._logger,
  );

  @override
  Future<void> signInWithStudentCode(
    String studentCode,
    String password,
  ) async {
    try {
      _logger.d(
        '[INFRASTRUCTURE] Obteniendo custom token de Firebase para: $studentCode',
      );

      // Obtener el custom token (manejando automáticamente la expiración)
      final customToken = await _customTokenManager.getValidCustomToken(
        studentCode: studentCode,
        password: password,
        tokenProvider:
            (studentCode, password) => _generateFirebaseCustomToken(
              studentCode: studentCode,
              password: password,
            ),
      );

      // Autenticar con Firebase usando el custom token
      final result = await _firebaseAuth.signInWithCustomToken(customToken);

      _logger.i(
        '[INFRASTRUCTURE] Sesión con custom token iniciada exitosamente (${result.user?.uid})',
      );
    } on FirebaseAuthException catch (e) {
      // Si el token es inválido, intentar forzar renovación una vez
      if (e.code == 'invalid-custom-token') {
        _logger.w(
          '[INFRASTRUCTURE] Custom token inválido, intentando renovar...',
        );
        try {
          final newToken = await _customTokenManager.forceRefreshToken(
            (studentCode, password) => _generateFirebaseCustomToken(
              studentCode: studentCode,
              password: password,
            ),
          );
          await _firebaseAuth.signInWithCustomToken(newToken);
          _logger.i('[INFRASTRUCTURE] Sesión iniciada con token renovado');
          return;
        } catch (retryError) {
          _logger.e('[INFRASTRUCTURE] Error en reintento: $retryError');
        }
      }

      _logger.e('[INFRASTRUCTURE] Error en signInWithCustomToken - ${e.code}');
      throw Exception('Error al iniciar sesión con custom token: ${e.message}');
    } catch (e) {
      _logger.e('[INFRASTRUCTURE] Error inesperado en signInWithCustomToken');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  Future<String> _generateFirebaseCustomToken({
    required String studentCode,
    required String password,
  }) async {
    try {
      _logger.d(
        '[INFRASTRUCTURE] Obteniendo Firebase custom token para: $studentCode',
      );

      final response = await _client.http.post(
        '/firebase/auth',
        data: {'username': studentCode, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;

        // Estructura nueva de la API
        final firebaseCustomToken = data?['firebaseCustomToken'] as String?;
        if (firebaseCustomToken != null) {
          final expiresIn = data?['expiresIn'] as int? ?? 3600;
          _logger.i(
            '[INFRASTRUCTURE] Firebase token obtenido (expira en ${expiresIn}s)',
          );
          return firebaseCustomToken;
        }

        // Fallback estructura legacy
        final legacyToken = data?['token'] as String?;
        if (legacyToken != null) {
          _logger.i(
            '[INFRASTRUCTURE] Firebase token obtenido (formato legacy)',
          );
          return legacyToken;
        }
      }

      throw Exception('Respuesta de Firebase auth inválida');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;

      _logger.e(
        '[INFRASTRUCTURE] Error obteniendo Firebase token: $studentCode - $statusCode',
      );

      switch (statusCode) {
        case 400:
        case 401:
          throw Exception('Credenciales académicas incorrectas');
        case 503:
          throw Exception('Servicio de autenticación no disponible');
        default:
          throw Exception('Error de conectividad: ${e.message}');
      }
    } catch (e) {
      _logger.e(
        '[INFRASTRUCTURE] Error inesperado obteniendo Firebase token: $e',
      );
      throw Exception('Error obteniendo Firebase token: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _logger.d('[INFRASTRUCTURE] Cerrando sesión en Firebase');

      // Limpiar custom token cacheado
      _customTokenManager.clearToken();

      await _firebaseAuth.signOut();

      _logger.i('[INFRASTRUCTURE] Sesión cerrada exitosamente');
    } catch (e) {
      _logger.e('[INFRASTRUCTURE] Error en signOut: $e');
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<String> getCurrentUid() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('Usuario no autenticado en Firebase');
    }
    return uid;
  }
}
