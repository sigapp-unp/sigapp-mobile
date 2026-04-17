import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.55);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hey, Unepino 👋',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Lottie.asset(
                        'assets/lottie/developer.json',
                        height: MediaQuery.of(context).size.width * 0.6,
                      ),
                      const SizedBox(height: 24),

                      // Bloque 1 — origen
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                              text:
                                  'Esta app nació en 2020, cuando aún era estudiante (7mo ciclo). Confieso que empezó como una ',
                            ),
                            const TextSpan(
                              text: 'afiebrada protesta',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const TextSpan(
                              text:
                                  ' ante, en mi opinión, la falta de innovación en los sistemas de la universidad.\n\nPero con el tiempo atrás quedó el rencor y pronto esta app se consolidó como ',
                            ),
                            TextSpan(
                              text: 'la',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' herramienta que ayudó a miles de estudiantes a gestionar su vida académica de forma más simple.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bloque 2 — cierre
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge,
                          children: [
                            const TextSpan(text: 'Hoy, '),
                            const TextSpan(
                              text: 'seis años después',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const TextSpan(
                              text:
                                  ', la universidad está estrenando un nuevo ecosistema digital.\n',
                            ),
                            const TextSpan(
                              text: 'Y eso es lo correcto.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => launchUrl(
                          Uri.parse('https://campusvirtual.unp.edu.pe/'),
                          mode: LaunchMode.externalApplication,
                        ),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Ir al Campus Virtual UNP'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'SIGApp cumplió su propósito.\nEs momento de cerrarla con cariño.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Bloque 3 — legado
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: secondaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: '6 años',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                            const TextSpan(text: ' en producción\n'),
                            TextSpan(
                              text: 'Decenas de miles',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                            const TextSpan(text: ' de estudiantes\n'),
                            TextSpan(
                              text: '4.9 ⭐',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                            const TextSpan(text: ' en Play Store'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gracias por haber confiado en ella durante todo este tiempo.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Bloque 4 — mensaje general
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                              text:
                                  'Si eres estudiante: no esperes a que todo mejore por sí solo. ',
                            ),
                            const TextSpan(
                              text: 'Encárgate.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Identifica un problema real.\nConstruye una solución.\nPublícala.\nAprende del proceso.\nAhí está tu aporte.',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Estoy seguro de que esta app ',
                            ),
                            const TextSpan(
                              text: 'dejó la vara alta',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const TextSpan(
                              text:
                                  ' para los sistemas que vengan. Es un legado del cual, honestamente, me siento muy orgulloso.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Bloque repo
                      Text(
                        'El código fuente de esta app es público.\nSi estás construyendo algo parecido, úsalo como referencia.',
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => launchUrl(
                          Uri.parse('https://github.com/sigapp-unp/sigapp-mobile'),
                          mode: LaunchMode.externalApplication,
                        ),
                        icon: const Icon(Icons.code),
                        label: const Text('Ver repositorio en GitHub'),
                      ),
                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Bloque 5 — a Informática
                      Image.asset('assets/custom_epii_logo.png', height: 120),
                      const SizedBox(height: 16),
                      Text(
                        'A los estudiantes de la Facultad de Ingeniería Industrial, en especial a la Escuela de Ingeniería Informática:',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                              text:
                                  'Hoy tienen herramientas que antes no teníamos.\nÚsenlas para ',
                            ),
                            const TextSpan(
                              text: 'aprender y construir',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                              text:
                                  ', no solo para consumir.\nDeja de quejarte y usa tu energía para ser parte del cambio.\nInvierte en IA y empieza a aprender (concienzudamente) y construir con modelos de frontera ',
                            ),
                            const TextSpan(
                              text: 'ya.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Firma
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '— José Daniel (promoción 2017), 17 de abril del 2026',
                          style: textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Entendido 🫡',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
