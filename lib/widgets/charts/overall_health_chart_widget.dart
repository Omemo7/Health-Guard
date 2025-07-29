// lib/widgets/charts/overall_health_chart_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/health_models.dart'; // Adjusted import path

class OverallHealthChartWidget extends StatelessWidget {
  final List<MonthlyHealthSummary> healthData;
  final Color barColor;
  final double? chartHeight; // Optional: Make height configurable

  const OverallHealthChartWidget({
    super.key,
    required this.healthData,
    required this.barColor,
    this.chartHeight = 200, // Default height
  });

  @override
  Widget build(BuildContext context) {
    if (healthData.isEmpty) {
      return SizedBox(
        height: chartHeight,
        child: const Card(
          elevation: 2,
          child: Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No health summary data available."),
          )),
        ),
      );
    }

    return SizedBox(
      height: chartHeight,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          // Adjusted padding
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              // Assuming score is 0-100
              minY: 0,
              barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${healthData[groupIndex].month}\n',
                        const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: rod.toY.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  )),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= healthData.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        // Increased padding
                        child: Text(
                          healthData[index].month,
                          style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 10),
                        ),
                      );
                    },
                    reservedSize: 32, // Adjusted reserved size
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36, // Adjusted reserved size
                    interval: 20, // Explicit interval
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            fontSize: 10),
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                ),
                topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: healthData
                  .asMap()
                  .map((index, data) =>
                  MapEntry(
                      index,
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                              toY: data.overallScore,
                              color: barColor,
                              width: 18, // Slightly wider bars
                              borderRadius: const BorderRadius.all(Radius
                                  .circular(5)))
                        ],
                      )))
                  .values
                  .toList(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme
                        .of(context)
                        .dividerColor
                        .withOpacity(0.5),
                    strokeWidth: 0.8,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}