import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/dashboard_model.dart';

class TicketTypeChart extends StatelessWidget {
  final List<TicketTypeDistribution> data;

  const TicketTypeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final total = data.fold<int>(0, (sum, item) => sum + item.count);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raspodjela tipova karata',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 160,
                height: 160,
                child: PieChart(
                  PieChartData(
                    sections: data.map((item) {
                      final percentage = (item.count / total) * 100;
                      return PieChartSectionData(
                        value: item.count.toDouble(),
                        title: percentage > 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                        color: item.color,
                        radius: 64,
                        titleStyle: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: data.map((item) {
                final percentage = (item.count / total) * 100;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
