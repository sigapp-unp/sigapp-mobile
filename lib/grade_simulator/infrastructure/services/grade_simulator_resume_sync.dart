import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/grade_simulator/infrastructure/services/grade_simulator_sync_manager.dart';
import 'package:sigapp/sync/infrastructure/services/resume_sync.dart';

/// Integrates with Flutter lifecycle for automatic sync on app resume
/// Handles connectivity recovery and background sync scenarios
@Singleton()
class GradeSimulatorResumeSync extends ResumeSync {
  GradeSimulatorResumeSync(Logger logger, GradeSimulatorSyncManager syncManager)
    : super(
        logger: logger,
        checkConnectivityRecovery: syncManager.checkConnectivityRecovery,
        processPendingOperations: syncManager.processPendingOperations,
      );
}
