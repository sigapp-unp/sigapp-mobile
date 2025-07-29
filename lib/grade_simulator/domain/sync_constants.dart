enum SyncStatus { pending, synced, failed }

extension SyncStatusExtension on SyncStatus {
  String get value => toString().split('.').last;
}

const int defaultMaxRetryCount = 3;
