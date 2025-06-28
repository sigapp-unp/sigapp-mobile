import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sigapp/core/config/environment_config.dart';
import 'package:sigapp/core/infrastructure/ui/app.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:sigapp/core/infrastructure/database/database_service.dart';
// import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvironmentConfig.loadEnvironment();

  await configureDependencies();

  // // Inicializar y verificar la base de datos antes de iniciar la app
  // final databaseClient = getIt<LocalDatabaseClient>();
  // try {
  //   // Verificar la integridad de la base de datos
  //   final hasIntegrity = await databaseClient.checkDatabaseIntegrity();
  //   developer.log(
  //       'Verificación de integridad de base de datos: ${hasIntegrity ? 'OK' : 'Falló'}',
  //       name: 'App Initialization');
  // } catch (e) {
  //   developer.log('Error al verificar la base de datos: $e',
  //       name: 'App Initialization');
  // }

  // if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
  //   await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  // }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const MyApp());
}
