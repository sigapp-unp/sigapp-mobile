import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/infrastructure/ui/app.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/core/infrastructure/app/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  final logger = getIt<Logger>();
  try {
    logger.i('Starting SigApp initialization...');

    final appInitializer = getIt<AppInitializer>();
    final initResult = await appInitializer.initializeApp();

    if (initResult.success) {
      logger.i('SigApp initialized successfully!');
    } else {
      logger.e('SigApp initialization failed: ${initResult.message}');
    }
  } catch (e) {
    logger.e('Critical initialization error: $e');
  }

  runApp(const MyApp());
}
