import 'package:flutter/material.dart';
import '../routes/routes.dart';
class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, 
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildNutrientsIndicator(),
            const SizedBox(height: 20),
            buildWaterIntake(),
            const SizedBox(height: 20),
            buildMealsSection(context),
          ],
        ),
      ),
    );
  }

  Widget buildNutrientsIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nutrients Indicator",
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              buildProgressRow("Proteins", 150, 225, Colors.red),
              buildProgressRow("Fats", 30, 118, Colors.orange),
              buildProgressRow("Carbs", 319, 340, Colors.teal),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 2456 / 3400,
                minHeight: 5,
                backgroundColor: Colors.grey[800],
                color: Colors.teal,
              ),
              const SizedBox(height: 4),
              const Text("2456 / 3400 Calories",
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProgressRow(String label, int value, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text("$value / $max", style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 3),
        LinearProgressIndicator(
          value: value / max,
          minHeight: 5,
          backgroundColor: Colors.grey[800],
          color: color,
        ),
      ],
    );
  }

  Widget buildWaterIntake() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Water Intake",
            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Water",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("1.9 / 2.5L", style: TextStyle(color: Colors.white, fontSize: 13)),
                    SizedBox(height: 4),
                    Text("Last time 10:45 AM", style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 36,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Text("76%", style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMealsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text("Meals",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black, size: 20),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.mealEdit);
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        mealCard("Breakfast", "10:45 AM", 531),
        const SizedBox(height: 8),
        mealCard("Lunch", "03:45 PM", 1024),
      ],
    );
  }

  Widget mealCard(String title, String time, int calories) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text("$calories Cal", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
