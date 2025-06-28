import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnvironment { local, production }

class EnvironmentConfig {
  static AppEnvironment get environment {
    if (kDebugMode) {
      return AppEnvironment.local;
    } else {
      return AppEnvironment.production;
    }
  }

  static String get environmentFileName {
    switch (environment) {
      case AppEnvironment.local:
        return 'environments/local.env';
      case AppEnvironment.production:
        return 'environments/prod.env';
    }
  }

  static Future<void> loadEnvironment() async {
    try {
      await dotenv.load(fileName: environmentFileName);
    } catch (e) {
      throw Exception(
        'Failed to load environment file: $e. Ensure the file exists at $environmentFileName',
      );
    }
  }
}
