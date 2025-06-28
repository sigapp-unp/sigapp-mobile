import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // X button in top right
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

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hey, Unepino 👋',
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Esto no es una app oficial de la universidad.',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                                  'Es un proyecto comunitario fundado con cariño por un exalumno (yo 🧉).',
                            ),
                            TextSpan(
                              text:
                                  '\n\nTu apoyo al proyecto es totalmente bienvenido, avísame si deseas ensuciarte las manos.',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Lottie.asset(
                        'assets/lottie/developer.json',
                        height: MediaQuery.of(context).size.width * 0.75,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                              text:
                                  'Si te gusta, puedes dejar 5 estrellas. Si algo falla, '
                                  'escríbeme directamente. Prometo responder (eventualmente).\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Nada de burocracia. Solo código, café, y buena fe.',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Thanks button at bottom
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Gracias', style: TextStyle(fontSize: 18)),
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
