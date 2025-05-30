import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry(this.date, this.weight);
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  final List<WeightEntry> weightEntries = [
    WeightEntry(DateTime(2022, 1, 21), 81.5),
    WeightEntry(DateTime(2022, 8, 31), 82),
    WeightEntry(DateTime(2023, 1, 1), 83.5),
    WeightEntry(DateTime(2023, 11, 16), 89.3),
    WeightEntry(DateTime(2024, 2, 29), 91),
  ];

  final TextEditingController weightController = TextEditingController();

  void showAddWeightDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Weight"),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: "Enter your weight (kg)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final enteredWeight = double.tryParse(weightController.text);
              if (enteredWeight != null) {
                setState(() {
                  weightEntries.add(
                    WeightEntry(DateTime.now(), enteredWeight),
                  );
                });
                weightController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWeightHeader(),
            const SizedBox(height: 12),
            buildWeightChart(),
            const SizedBox(height: 20),
            buildResultsHeader(),
            const SizedBox(height: 10),
            ...weightEntries
                .reversed
                .map((entry) => buildResultCard(entry))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget buildWeightHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Weight",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          "From beginning",
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget buildWeightChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 35),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  );
                },
                interval: 1,
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          minY: 75,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: weightEntries.map((e) {
                final yearDecimal = e.date.year.toDouble() + (e.date.month / 12);
                return FlSpot(yearDecimal, e.weight);
              }).toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Results",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        IconButton(
          icon: const Icon(Icons.add, size: 20, color: Colors.black),
          onPressed: showAddWeightDialog,
        ),
      ],
    );
  }

  Widget buildResultCard(WeightEntry entry) {
    final formattedDate = DateFormat('MMM d, yyyy').format(entry.date);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          Text(
            "${entry.weight} kg",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
