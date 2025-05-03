import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = Colors.black;
    final textColor = Colors.white;
    final accentColor = Colors.tealAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          "Itami",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark(), 
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                // Update the selected date and reload meals
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Nutrients Indicator
            nutrientIndicator(textColor, accentColor),

            const SizedBox(height: 20),

            /// Water Intake
            waterIntakeCard(textColor, accentColor),

            const SizedBox(height: 20),

            /// Meals
            mealCard("Breakfast", 531, textColor, accentColor),
            const SizedBox(height: 12),
            mealCard("Lunch", 1024, textColor, accentColor),
            // Add more meals if needed
          ],
        ),
      ),
    );
  }

  Widget nutrientIndicator(Color textColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nutrients Indicator", style: TextStyle(color: textColor, fontSize: 18)),
        const SizedBox(height: 10),
        progressRow("Proteins", 150, 225, textColor, accentColor),
        progressRow("Fats", 30, 118, textColor, accentColor),
        progressRow("Carbs", 319, 340, textColor, accentColor),
        const SizedBox(height: 10),
        Text("2456 / 3400 Calories", style: TextStyle(color: accentColor)),
      ],
    );
  }

  Widget progressRow(String label, int value, int max, Color textColor, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $value / $max", style: TextStyle(color: textColor)),
        LinearProgressIndicator(
          value: value / max,
          backgroundColor: Colors.grey[800],
          color: accentColor,
          minHeight: 6,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget waterIntakeCard(Color textColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Water Intake", style: TextStyle(color: textColor)),
              Text("1.9 / 2.5L", style: TextStyle(color: accentColor)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: accentColor,
              shape: const CircleBorder(),
            ),
            onPressed: () {},
            child: const Icon(Icons.remove),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              foregroundColor: accentColor,
              shape: const CircleBorder(),
            ),
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget mealCard(String title, int calories, Color textColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: textColor, fontSize: 16)),
              const SizedBox(height: 4),
              Text("$calories Cal", style: TextStyle(color: accentColor)),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
        ],
      ),
    );
  }
}
