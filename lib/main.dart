import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sigapp/core/config/environment_config.dart';
import 'package:sigapp/core/infrastructure/ui/app.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment configuration first
  await EnvironmentConfig.loadEnvironment();

  // 2. Initialize Firebase before dependency injection
  await _initializeFirebase();

  // 3. Configure dependency injection (now Firebase services are available)
  await configureDependencies();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode) {
      // Configure Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Capture unhandled async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization failed: $e');
    }
    rethrow;
  }
}
