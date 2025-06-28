import 'package:flutter/material.dart';

class EmptyIconWidget extends StatelessWidget {
  const EmptyIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [Icon(Icons.abc, color: Colors.transparent)]);
  }
}
