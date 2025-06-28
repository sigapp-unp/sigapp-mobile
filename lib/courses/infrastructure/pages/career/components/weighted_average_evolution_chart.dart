import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sigapp/courses/domain/entities/academic_history_term.dart';

class WeightedAverageEvolutionChartWidget extends StatelessWidget {
  const WeightedAverageEvolutionChartWidget({
    super.key,
    required this.academicHistory,
  });

  final List<AcademicHistoryTerm> academicHistory;

  @override
  Widget build(BuildContext context) {
    return _buildChart(context, academicHistory);
  }

  Widget _buildChart(
    BuildContext context,
    List<AcademicHistoryTerm> academicHistory,
  ) {
    // Filter only those terms that have statistics
    final termsWithStats =
        academicHistory.where((t) => t.statistics != null).toList();
    if (termsWithStats.isEmpty) {
      return const SizedBox.shrink();
    }

    // We'll keep track of both lines: semestral average and cumulative average
    final List<FlSpot> semestralSpots = [];
    final List<FlSpot> acumuladoSpots = [];

    // We'll determine min and max for Y (averages),
    // while X (semesters) is straightforward: from 1 to numberOfTerms
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var i = 0; i < termsWithStats.length; i++) {
      final stats = termsWithStats[i].statistics!;
      final semesterIndex = (i + 1).toDouble(); // X: semester number

      // Y values for semestral and cumulative weighted averages
      final semestral = stats.termWeightedAverage;
      final acumulado = stats.cumulativeWeightedAverage;

      // Build the spots for the chart
      semestralSpots.add(FlSpot(semesterIndex, semestral));
      acumuladoSpots.add(FlSpot(semesterIndex, acumulado));

      // Update min and max for Y
      if (semestral < minY) minY = semestral;
      if (semestral > maxY) maxY = semestral;
      if (acumulado < minY) minY = acumulado;
      if (acumulado > maxY) maxY = acumulado;
    }

    // We add some margin so the lines don't stick to the borders
    const marginFactor = 0.1;
    final yRange = maxY - minY;
    final double finalMinY =
        (yRange > 0) ? minY - yRange * marginFactor : minY - 1;
    final double finalMaxY =
        (yRange > 0) ? maxY + yRange * marginFactor : maxY + 1;

    // For X, we can assume 1 to termsWithStats.length, plus a little margin
    final double finalMinX = 0.5;
    final double finalMaxX = termsWithStats.length + 0.5;

    final semestralColor = Colors.blue;
    final lineSemestral = LineChartBarData(
      spots: semestralSpots,
      isCurved: true,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      color: semestralColor,
    );

    final acumuladoColor = Colors.red;
    final lineAcumulado = LineChartBarData(
      spots: acumuladoSpots,
      isCurved: true,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      color: acumuladoColor,
    );

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelLarge,
              children: [
                TextSpan(text: 'Promedio ponderado '),
                TextSpan(
                  text: 'semestral',
                  style: TextStyle(color: semestralColor),
                ),
                TextSpan(text: ' vs '),
                TextSpan(
                  text: 'acumulado',
                  style: TextStyle(color: acumuladoColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                minX: finalMinX,
                maxX: finalMaxX,
                minY: finalMinY,
                maxY: finalMaxY,
                lineBarsData: [lineSemestral, lineAcumulado],
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.black12),
                    bottom: BorderSide(color: Colors.black12),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                titlesData: FlTitlesData(
                  // Bottom axis: semesters
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) {
                        final semesterNumber = value.toInt();
                        if (semesterNumber < 1 ||
                            semesterNumber > termsWithStats.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          'S$semesterNumber',
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  // Left axis: weighted average
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, _) {
                        // Round or format as needed
                        return Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
