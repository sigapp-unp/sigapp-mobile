import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/ui/app.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/core/infrastructure/app/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  // Centralized app initialization using AppInitializer
  final appInitializer = getIt<AppInitializer>();
  final logger = getIt<Logger>();

  try {
    logger.i('Starting SigApp initialization...');

    final initResult = await appInitializer.initializeApp();

    if (initResult.success) {
      logger.i('SigApp initialized successfully!');
    } else {
      logger.e('SigApp initialization failed: ${initResult.message}');
      // App can continue functioning even with some errors
    }
  } catch (e) {
    logger.e('Critical initialization error: $e');
    // In case of critical error, app should show error message
  }

  // if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
  //   await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  // }

  runApp(const MyApp());
}
