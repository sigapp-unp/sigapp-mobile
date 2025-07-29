/// DTOs for sync queue infrastructure reporting

/// Infrastructure DTO for detailed statistics reporting
class DetailedQueueStatistics {
  final Map<String, StatusBreakdown> statusBreakdown;
  final Map<String, Map<String, int>> typeBreakdown;
  final int totalOperations;
  final String generatedAt;

  const DetailedQueueStatistics({
    required this.statusBreakdown,
    required this.typeBreakdown,
    required this.totalOperations,
    required this.generatedAt,
  });

  Map<String, dynamic> toMap() => {
    'status_breakdown': statusBreakdown.map((k, v) => MapEntry(k, v.toMap())),
    'type_breakdown': typeBreakdown,
    'total_operations': totalOperations,
    'generated_at': generatedAt,
  };

  @override
  String toString() =>
      'DetailedQueueStatistics(total: $totalOperations, generated: $generatedAt)';
}

/// Infrastructure helper for status breakdown reporting
class StatusBreakdown {
  final int count;
  final double avgRetryCount;

  const StatusBreakdown({required this.count, required this.avgRetryCount});

  Map<String, dynamic> toMap() => {
    'count': count,
    'avg_retry_count': avgRetryCount,
  };

  @override
  String toString() =>
      'StatusBreakdown(count: $count, avgRetry: $avgRetryCount)';
}
