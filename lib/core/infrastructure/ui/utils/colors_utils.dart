import 'package:flutter/material.dart';

class ColorsUtils {
  ColorsUtils._();

  static Color getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  static const _colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
    Colors.lime,
    Colors.amber,
  ];

  static Color getColorByIndex(int index) {
    return _colorList.elementAtOrNull(
          index < _colorList.length ? index : index % _colorList.length,
        ) ??
        Colors.grey;
  }
}
