// stateless
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key, required this.message, this.onRetry});

  factory ErrorStateWidget.from(Object error, {void Function()? onRetry}) {
    String message;
    if (error is String) {
      message = error;
    } else if (error.runtimeType.toString().contains('DioException') ||
        error.toString().contains('SocketException') ||
        error.toString().contains('Network')) {
      message = 'No hay conexión a internet. Por favor, verifica tu conexión.';
    } else {
      message = 'Ha ocurrido un error inesperado.';
    }
    return ErrorStateWidget(message: message, onRetry: onRetry);
  }

  final String message;
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
