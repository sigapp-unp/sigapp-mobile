import 'package:flutter/material.dart';

class DayHeaderWidget extends StatelessWidget {
  final int day;

  const DayHeaderWidget({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    String dayLabel;
    switch (day) {
      case 1:
        dayLabel = 'Lun';
        break;
      case 2:
        dayLabel = 'Mar';
        break;
      case 3:
        dayLabel = 'Mie';
        break;
      case 4:
        dayLabel = 'Jue';
        break;
      case 5:
        dayLabel = 'Vie';
        break;
      case 6:
        dayLabel = 'Sab';
        break;
      case 7:
        dayLabel = 'Dom';
        break;
      default:
        dayLabel = '';
    }
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Center(child: Text(dayLabel)),
      ),
    );
  }
}
