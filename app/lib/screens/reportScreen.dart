import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final bgColor = Colors.black;
    final cardColor = Colors.grey[900];
    final accentColor = Colors.greenAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/images/avatar.png"), // Replace with real image
              radius: 16,
            ),
            const SizedBox(width: 10),
            Text("Itami", style: TextStyle(color: textColor)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Weight + Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weight", style: TextStyle(color: textColor, fontSize: 20)),
                DropdownButton<String>(
                  value: "From beginning",
                  dropdownColor: cardColor,
                  style: TextStyle(color: accentColor),
                  underline: Container(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: "From beginning", child: Text("From beginning")),
                    DropdownMenuItem(value: "Last 30 days", child: Text("Last 30 days")),
                    DropdownMenuItem(value: "Last 6 months", child: Text("Last 6 months")),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weight Line Chart
            buildWeightChart(accentColor),

            const SizedBox(height: 16),

            // Results Header + Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Results", style: TextStyle(color: textColor, fontSize: 16)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            // Results List
            Expanded(
              child: ListView(
                children: [
                  weightTile("Jan 21, 2022", "81.5 kg", textColor, cardColor),
                  weightTile("Aug 31, 2022", "82 kg", textColor, cardColor),
                  weightTile("Jan 1, 2023", "83.5 kg", textColor, cardColor),
                  weightTile("Nov 16, 2023", "89.3 kg", textColor, cardColor),
                  weightTile("Feb 29, 2024", "91 kg", textColor, cardColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeightChart(Color accentColor) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(2022, 81.5),
                FlSpot(2022.7, 82),
                FlSpot(2023, 83.5),
                FlSpot(2023.9, 89.3),
                FlSpot(2024, 91),
              ],
              isCurved: true,
              color: accentColor,
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
          minX: 2022,
          maxX: 2024,
          minY: 75,
          maxY: 100,
        ),
      ),
    );
  }

  Widget weightTile(String date, String weight, Color textColor, Color? bgColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(color: textColor)),
          Text(weight, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
