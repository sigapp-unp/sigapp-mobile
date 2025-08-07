import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class FirebaseCustomTokenManager {
  final Logger _logger;
  final FlutterSecureStorage _secureStorage;

  String? _currentToken;
  DateTime? _tokenExpiryTime;
  String? _cachedStudentCode;
  String? _cachedPassword;

  static const Duration _tokenValidityDuration = Duration(minutes: 30);

  static const Duration _refreshBuffer = Duration(minutes: 5);

  static const String _tokenKey = 'firebase_custom_token';
  static const String _tokenExpiryKey = 'firebase_token_expiry';

  FirebaseCustomTokenManager(this._logger, this._secureStorage);

  Future<String> getValidCustomToken({
    required String studentCode,
    required String password,
    required Future<String> Function(String studentCode, String password)
    tokenProvider,
  }) async {
    _cachedStudentCode = studentCode;
    _cachedPassword = password;

    // Intentar cargar token persistido si no tenemos uno en memoria
    if (_currentToken == null || _tokenExpiryTime == null) {
      await _loadPersistedToken();
    }

    if (_shouldRefreshToken()) {
      await _refreshCustomToken(studentCode, password, tokenProvider);
      await _persistToken(); // Persistir después de renovar
    }

    if (_currentToken == null) {
      throw Exception('No se pudo obtener Firebase custom token');
    }

    return _currentToken!;
  }

  bool _shouldRefreshToken() {
    if (_currentToken == null || _tokenExpiryTime == null) {
      return true;
    }

    final timeToExpiry = _tokenExpiryTime!.difference(DateTime.now());
    return timeToExpiry <= _refreshBuffer;
  }

  Future<void> _refreshCustomToken(
    String studentCode,
    String password,
    Future<String> Function(String studentCode, String password) tokenProvider,
  ) async {
    try {
      _logger.d(
        '[AUTH] Obteniendo nuevo Firebase custom token para: $studentCode',
      );

      final newToken = await tokenProvider(studentCode, password);

      _currentToken = newToken;
      _tokenExpiryTime = DateTime.now().add(_tokenValidityDuration);

      _logger.i(
        '[AUTH] Firebase custom token renovado exitosamente. Expira: $_tokenExpiryTime',
      );
    } catch (e) {
      _logger.e('[AUTH] Error renovando Firebase custom token: $e');
      rethrow;
    }
  }

  /// Cargar token persistido desde secure storage
  Future<void> _loadPersistedToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);

      if (token != null && expiryString != null) {
        final expiry = DateTime.tryParse(expiryString);
        if (expiry != null && DateTime.now().isBefore(expiry)) {
          _currentToken = token;
          _tokenExpiryTime = expiry;
          _logger.d(
            '[AUTH] Token cargado desde secure storage. Expira: $expiry',
          );
        } else {
          _logger.d('[AUTH] Token persistido expirado, será renovado');
          await _clearPersistedToken();
        }
      }
    } catch (e) {
      _logger.w('[AUTH] Error cargando token persistido: $e');
      // No es crítico, continuamos sin token persistido
    }
  }

  /// Persistir token actual en secure storage
  Future<void> _persistToken() async {
    if (_currentToken != null && _tokenExpiryTime != null) {
      try {
        await _secureStorage.write(key: _tokenKey, value: _currentToken!);
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: _tokenExpiryTime!.toIso8601String(),
        );
        _logger.d('[AUTH] Token persistido en secure storage');
      } catch (e) {
        _logger.w('[AUTH] Error persistiendo token: $e');
        // No es crítico, la app funcionará con tokens en memoria
      }
    }
  }

  /// Limpiar token persistido
  Future<void> _clearPersistedToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);
    } catch (e) {
      _logger.w('[AUTH] Error limpiando token persistido: $e');
    }
  }

  Future<String> forceRefreshToken(
    Future<String> Function(String studentCode, String password) tokenProvider,
  ) async {
    if (_cachedStudentCode == null || _cachedPassword == null) {
      throw Exception('No hay credenciales cacheadas para renovar el token');
    }

    _logger.w('[AUTH] Forzando renovación de Firebase custom token');
    await _refreshCustomToken(
      _cachedStudentCode!,
      _cachedPassword!,
      tokenProvider,
    );
    await _persistToken(); // Persistir token renovado
    return _currentToken!;
  }

  void clearToken() {
    _logger.d('[AUTH] Limpiando Firebase custom token');
    _currentToken = null;
    _tokenExpiryTime = null;
    _cachedStudentCode = null;
    _cachedPassword = null;

    // Limpiar también el token persistido de forma asíncrona
    _clearPersistedToken().catchError((e) {
      _logger.w(
        '[AUTH] Error limpiando token persistido durante clearToken: $e',
      );
    });
  }

  bool get hasValidToken {
    return _currentToken != null &&
        _tokenExpiryTime != null &&
        DateTime.now().isBefore(_tokenExpiryTime!);
  }

  Duration? get timeToExpiry {
    if (_tokenExpiryTime == null) return null;
    final remaining = _tokenExpiryTime!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
