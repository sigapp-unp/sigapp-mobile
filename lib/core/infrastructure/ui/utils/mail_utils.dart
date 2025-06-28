import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class MailUtils {
  final Logger _logger;

  MailUtils(this._logger);

  void launchEmail(
    BuildContext context, {
    required String email,
    String? subject,
    String? body,
  }) async {
    // iOS: you need to ios/Runner/Info.plist
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: {
        'subject': Uri.encodeComponent(subject ?? ''),
        'body': Uri.encodeComponent(body ?? ''),
      }.entries.map((e) => '${e.key}=${e.value}').join('&'),
    );

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e, s) {
      _logger.e('[UI] Error launching email app: $e', error: e, stackTrace: s);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al abrir el correo')),
      );
    }
  }
}
