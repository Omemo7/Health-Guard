// lib/widgets/charts/vital_chart_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../models/health_models/VitalDataPoint.dart';
import '../../models/health_models/VitalLogEntry.dart'; // For date formatting

class VitalChartWidget extends StatelessWidget {
  final List<VitalDataPoint> dataPoints;
  final String vitalName; // e.g., "Heart Rate (bpm)"
  final VitalType vitalType; // For type-specific logic like decimal places
  final Color lineColor;
  final double? chartHeight; // Optional: Make height configurable

  const VitalChartWidget({
    super.key,
    required this.dataPoints,
    required this.vitalName,
    required this.vitalType,
    required this.lineColor,
    this.chartHeight = 190, // Default height
  });

  @override
  Widget build(BuildContext context) {
    Widget chartContent;

    if (dataPoints.isEmpty) {
      chartContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("No data available for $vitalName."),
        ),
      );
    } else {
      double minY = double.maxFinite;
      double maxY = double.minPositive;
      for (var p in dataPoints) {
        if (p.value < minY) minY = p.value;
        if (p.value > maxY) maxY = p.value;
      }

      // Add padding to min/max Y, ensure valid range
      double paddingY = (maxY - minY) * 0.1; // 10% padding
      if (paddingY < 2) paddingY = 2; // Minimum padding of 2 units
      minY = (minY - paddingY).floorToDouble();
      maxY = (maxY + paddingY).ceilToDouble();

      if (minY == maxY) { // Avoid issues if all values are the same
        minY -= 5;
        maxY += 5;
      }
      if (minY < 0 && vitalType != VitalType.temperature) minY = 0;

      final List<FlSpot> spots = dataPoints
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.value))
          .toList();

      chartContent = LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: (maxY - minY) / 4 > 0 ? (maxY - minY) / 4 : 1,
            // Ensure interval is positive
            verticalInterval: (spots.length / 5) > 1 ? (spots.length / 5)
                .floorToDouble() : 1,
            // Ensure interval is positive and integer
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Theme
                    .of(context)
                    .dividerColor
                    .withOpacity(0.5), strokeWidth: 0.8),
            getDrawingVerticalLine: (value) =>
                FlLine(color: Theme
                    .of(context)
                    .dividerColor
                    .withOpacity(0.5), strokeWidth: 0.8),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: (maxY - minY) / 4 > 0 ? (maxY - minY) / 4 : 1,
                // Ensure interval is positive
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    // No decimals for Y-axis labels usually
                    style: TextStyle(fontSize: 10, color: Theme
                        .of(context)
                        .colorScheme
                        .onSurfaceVariant),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                // Increased reserved size for formatted dates
                interval: (spots.length / 4).ceilToDouble() > 0 ? (spots
                    .length / 4).ceilToDouble() : 1,
                // Ensure interval is positive
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < dataPoints.length) {
                    // Show fewer labels for clarity
                    if (index == 0 || index == dataPoints.length - 1 ||
                        spots.length <= 5 ||
                        index % ((spots.length / 3).ceil()) == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('d/M').format(dataPoints[index].date),
                          // Use intl for formatting
                          style: TextStyle(fontSize: 10, color: Theme
                              .of(context)
                              .colorScheme
                              .onSurfaceVariant),
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
              show: true,
              border: Border.all(color: Theme
                  .of(context)
                  .dividerColor, width: 1)),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.2),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true, // Enable default touch behaviors
            touchTooltipData: LineTouchTooltipData(

              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = dataPoints[spot.spotIndex].date;
                  return LineTooltipItem(
                      '${DateFormat('MMM d, yyyy').format(date)}\n',
                      const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      children: [
                        TextSpan(
                          text: spot.y.toStringAsFixed(
                              vitalType == VitalType.temperature ? 1 : 0),
                          style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        )
                      ]);
                }).toList();
              },
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vitalName, style: Theme
                .of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16.0),
            SizedBox(
              height: chartHeight,
              child: chartContent,
            ),
          ],
        ),
      ),
    );
  }
}