import 'package:flutter/material.dart';

class EasterEggPageWidget extends StatelessWidget {
  const EasterEggPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easter Egg 🥚')),
      body: ListView(
        children: [
          // assets\custom_epii_logo.png
          Image.asset('assets/custom_epii_logo.png'),
        ],
      ),
    );
  }
}
