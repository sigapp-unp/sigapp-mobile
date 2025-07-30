/// Represents queue statistics as a domain concept
class QueueStats {
  final int pending;
  final int synced;
  final int failed;

  const QueueStats({
    required this.pending,
    required this.synced,
    required this.failed,
  });

  int get total => pending + synced + failed;

  factory QueueStats.empty() =>
      const QueueStats(pending: 0, synced: 0, failed: 0);

  Map<String, int> toMap() => {
    'pending': pending,
    'synced': synced,
    'failed': failed,
  };

  @override
  String toString() =>
      'QueueStats(pending: $pending, synced: $synced, failed: $failed)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueStats &&
          runtimeType == other.runtimeType &&
          pending == other.pending &&
          synced == other.synced &&
          failed == other.failed;

  @override
  int get hashCode => pending.hashCode ^ synced.hashCode ^ failed.hashCode;
}

/// Domain value object for performance metrics
class PerformanceMetrics {
  final int totalOperations;
  final int pendingOperations;
  final int failedOperations;
  final int operationsWithRetries;
  final double averageRetryCount;
  final int maxRetryCount;
  final double queueAgeHours;
  final DateTime measuredAt;

  const PerformanceMetrics({
    required this.totalOperations,
    required this.pendingOperations,
    required this.failedOperations,
    required this.operationsWithRetries,
    required this.averageRetryCount,
    required this.maxRetryCount,
    required this.queueAgeHours,
    required this.measuredAt,
  });

  Map<String, dynamic> toMap() => {
    'total_operations': totalOperations,
    'pending_operations': pendingOperations,
    'failed_operations': failedOperations,
    'operations_with_retries': operationsWithRetries,
    'average_retry_count': averageRetryCount,
    'max_retry_count': maxRetryCount,
    'queue_age_hours': queueAgeHours,
    'measured_at': measuredAt.toIso8601String(),
  };

  @override
  String toString() =>
      'PerformanceMetrics(total: $totalOperations, pending: $pendingOperations)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceMetrics &&
          runtimeType == other.runtimeType &&
          totalOperations == other.totalOperations &&
          pendingOperations == other.pendingOperations &&
          failedOperations == other.failedOperations &&
          operationsWithRetries == other.operationsWithRetries &&
          averageRetryCount == other.averageRetryCount &&
          maxRetryCount == other.maxRetryCount &&
          queueAgeHours == other.queueAgeHours &&
          measuredAt == other.measuredAt;

  @override
  int get hashCode =>
      totalOperations.hashCode ^
      pendingOperations.hashCode ^
      failedOperations.hashCode ^
      operationsWithRetries.hashCode ^
      averageRetryCount.hashCode ^
      maxRetryCount.hashCode ^
      queueAgeHours.hashCode ^
      measuredAt.hashCode;
}

/// Domain value object representing a sync operation
class SyncOperation {
  final String operationType;
  final String entityType;
  final String entityKey;
  final String fieldType;
  final Map<String, dynamic> operationData;

  const SyncOperation({
    required this.operationType,
    required this.entityType,
    required this.entityKey,
    required this.fieldType,
    required this.operationData,
  });

  Map<String, dynamic> toMap() => {
    'operationType': operationType,
    'entityType': entityType,
    'entityKey': entityKey,
    'fieldType': fieldType,
    'operationData': operationData,
  };

  @override
  String toString() =>
      'SyncOperation(type: $operationType, entity: $entityKey)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncOperation &&
          runtimeType == other.runtimeType &&
          operationType == other.operationType &&
          entityType == other.entityType &&
          entityKey == other.entityKey &&
          fieldType == other.fieldType;

  @override
  int get hashCode =>
      operationType.hashCode ^
      entityType.hashCode ^
      entityKey.hashCode ^
      fieldType.hashCode;
}
