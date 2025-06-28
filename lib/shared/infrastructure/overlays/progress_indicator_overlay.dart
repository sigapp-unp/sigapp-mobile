import 'package:flutter/material.dart';

class ProgressIndicatorOverlayWidget extends StatelessWidget {
  const ProgressIndicatorOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
