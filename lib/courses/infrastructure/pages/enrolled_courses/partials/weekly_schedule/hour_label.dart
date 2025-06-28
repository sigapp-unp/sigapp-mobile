import 'package:flutter/material.dart';

class HourLabelWidget extends StatelessWidget {
  final int hour;
  final double rowHeight;
  final double littleRayLength;
  final double hourWidth;

  const HourLabelWidget({
    super.key,
    required this.hour,
    required this.rowHeight,
    required this.littleRayLength,
    required this.hourWidth,
  });

  @override
  Widget build(BuildContext context) {
    String period = hour >= 12 ? 'pm' : 'am';
    int displayHour = hour > 12 ? hour - 12 : hour;
    displayHour = displayHour == 0 ? 12 : displayHour;
    String formattedHour = '$displayHour$period';

    return SizedBox(
      width: hourWidth,
      height: rowHeight,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: littleRayLength,
              height: 1,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
          Container(alignment: Alignment.topCenter, child: Text(formattedHour)),
        ],
      ),
    );
  }
}
