import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sigapp/core/infrastructure/ui/utils/colors_utils.dart';

class GenericPieChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final List<Color> colors;

  const GenericPieChart({
    super.key,
    required this.values,
    required this.labels,
    required this.colors,
  }) : assert(
         values.length == labels.length && labels.length == colors.length,
         'Length of values, labels and colors must match.',
       );

  @override
  State<GenericPieChart> createState() => _GenericPieChartState();
}

class _GenericPieChartState extends State<GenericPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.values.fold(0.0, (a, b) => a + b);
    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response?.touchedSection == null) {
                      touchedIndex = -1;
                    } else {
                      touchedIndex =
                          response!.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _buildSections(total),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.labels.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _Indicator(
                color: widget.colors[i],
                text: widget.labels[i],
                isSquare: true,
              ),
            );
          }),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    final radius = MediaQuery.of(context).size.width * 0.1;
    return List.generate(widget.values.length, (i) {
      final isTouched = i == touchedIndex;
      final percentage = total == 0 ? 0 : (widget.values[i] / total * 100);
      return PieChartSectionData(
        color: widget.colors[i],
        value: widget.values[i],
        title: '${percentage.toStringAsFixed(1)}%',
        radius: !isTouched ? radius : radius * 1.1,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorsUtils.getTextColor(widget.colors[i]),
          shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
      );
    });
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const _Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
