import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';

/// Simple conflict resolution for multi-device scenarios
/// Implements Last-Write-Wins pattern based on timestamps
@LazySingleton()
class ConflictResolver {
  final Logger _logger;

  ConflictResolver(this._logger);

  /// Resolve conflict using Last-Write-Wins strategy
  /// Compares timestamps and newer version wins
  T resolveLastWriteWins<T extends Timestamped>({
    required T localVersion,
    required T serverVersion,
    required String entityDescription,
  }) {
    final localTimestamp = localVersion.timestamp;
    final serverTimestamp = serverVersion.timestamp;

    if (localTimestamp.isAfter(serverTimestamp)) {
      // Local version is newer - use local
      _logger.i(
        '[CONFLICT_RESOLVER] $entityDescription: Local wins (${localTimestamp.toIso8601String()} > ${serverTimestamp.toIso8601String()})',
      );
      return localVersion;
    } else {
      // Server version is newer or equal - use server
      _logger.i(
        '[CONFLICT_RESOLVER] $entityDescription: Server wins (${serverTimestamp.toIso8601String()} >= ${localTimestamp.toIso8601String()})',
      );
      return serverVersion;
    }
  }

  /// Verificar si hay conflicto (timestamps diferentes)
  bool hasConflict<T extends Timestamped>(T local, T server) {
    return local.timestamp != server.timestamp;
  }

  /// Crear versión con timestamp actualizado para force update
  Map<String, dynamic> createForceUpdateData<T extends Timestamped>({
    required T winningVersion,
    required Map<String, dynamic> additionalData,
  }) {
    return {
      ...additionalData,
      'timestamp': winningVersion.timestamp.toIso8601String(),
      'force_update': true, // Flag para indicar que es force update
    };
  }
}
