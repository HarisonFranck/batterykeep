// lib/components/BatteryHistoryChart.dart
import 'package:batterykeep/features/battery_monitor/data/models/BatterySample.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BatteryHistoryChart extends StatelessWidget {
  final List<BatterySample> samples;

  const BatteryHistoryChart({super.key, required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return const Center(
        child: Text(
          "Historique en cours de collecte...",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final firstTimestamp = samples.first.timestamp.millisecondsSinceEpoch;

    final spots = samples.map((s) {
      final xHours =
          (s.timestamp.millisecondsSinceEpoch - firstTimestamp) /
          (1000 * 60 * 60);
      return FlSpot(xHours, s.percentage.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.white.withOpacity(0.08), strokeWidth: 1),
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                "${value.toInt()}%",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 6, // toutes les 6h
              getTitlesWidget: (value, meta) {
                final time = samples.first.timestamp.add(
                  Duration(hours: value.toInt()),
                );
                return Text(
                  "${time.hour.toString().padLeft(2, '0')}:00",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.25),
                  Colors.green.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
