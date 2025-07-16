import 'package:in_app_update/in_app_update.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

/// Service to handle in-app updates for Android using Google Play Core API
@singleton
class UpdateService {
  // static final _logger = Logger();
  final Logger _logger;

  UpdateService(this._logger);

  /// Checks for available updates and performs the appropriate update flow
  ///
  /// Uses Google Play's official API to:
  /// - Check if an update is available
  /// - Determine if immediate or flexible update should be used
  /// - Handle the update process accordingly
  Future<void> checkForUpdate() async {
    try {
      _logger.i('Checking for app updates...');

      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        _logger.i('Update available. Priority: ${info.updatePriority}');

        // Immediate if Play allows it and priority is high (4-5)
        if (info.immediateUpdateAllowed && info.updatePriority >= 4) {
          _logger.i('Performing immediate update...');
          await InAppUpdate.performImmediateUpdate();
        }
        // Otherwise, try flexible update
        else if (info.flexibleUpdateAllowed) {
          _logger.i('Starting flexible update...');
          final result = await InAppUpdate.startFlexibleUpdate();

          // Only complete if download was successful
          if (result == AppUpdateResult.success) {
            _logger.i('Completing flexible update...');
            await InAppUpdate.completeFlexibleUpdate();
          } else {
            _logger.w('Flexible update not finished: $result');
          }
        } else {
          _logger.w('Update available but no flow allowed.');
          _debugPreconditions(info);
        }
      } else {
        _logger.i('No update available');
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error checking for updates: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Checks if a flexible update is ready to be installed
  Future<bool> isFlexibleUpdateReady() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      return info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress;
    } catch (e) {
      _logger.e('Error checking flexible update status: $e');
      return false;
    }
  }

  /// Completes a flexible update that has been downloaded
  Future<void> completeFlexibleUpdate() async {
    try {
      _logger.i('Completing flexible update...');
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      _logger.e('Error completing flexible update: $e');
    }
  }

  /// Debug method to log why update preconditions are not met
  void _debugPreconditions(AppUpdateInfo info) {
    if (!info.immediateUpdateAllowed &&
        info.immediateAllowedPreconditions != null) {
      _logger.d(
        'Immediate preconditions blocking: ${info.immediateAllowedPreconditions}',
      );
    }
    if (!info.flexibleUpdateAllowed &&
        info.flexibleAllowedPreconditions != null) {
      _logger.d(
        'Flexible preconditions blocking: ${info.flexibleAllowedPreconditions}',
      );
    }
  }
}
