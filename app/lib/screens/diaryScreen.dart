import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../routes/routes.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  double currentWater = 0;
  final double waterGoal = 2.5;
  final double step = 0.2;

  List<Meal> todayMeals = [];
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;

  @override
  void initState() {
    super.initState();
    fetchTodayMeals();
  }

  Future<void> fetchTodayMeals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .get();

    final meals = snapshot.docs.map((doc) => Meal.fromMap(doc.data(), doc.id)).toList();

    double cal = 0, prot = 0, carb = 0, fat = 0;
    for (var meal in meals) {
      cal += meal.totalCalories;
      prot += meal.totalProtein;
      carb += meal.totalCarbs;
      fat += meal.totalFat;
    }

    setState(() {
      todayMeals = meals;
      totalCalories = cal;
      totalProtein = prot;
      totalCarbs = carb;
      totalFat = fat;
    });
  }

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
        const Text(
          "Nutrients Indicator",
          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildNutrientColumn("Proteins", totalProtein, 225, Colors.red),
                  buildNutrientColumn("Fats", totalFat, 118, Colors.orange),
                  buildNutrientColumn("Carbs", totalCarbs, 340, Colors.teal),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "${totalCalories.round()} / 2700 Calories",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: (totalCalories / 2700).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: Colors.grey[800],
                color: Colors.tealAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNutrientColumn(String label, double value, int max, Color color) {
    return Column(
      children: [
        Text(
          "${value.round()} / $max",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: (value / max).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: Colors.grey[800],
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget buildWaterIntake() {
    double percentage = (currentWater / waterGoal).clamp(0.0, 1.0);
    int percentDisplay = (percentage * 100).round();

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Water",
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("${currentWater.toStringAsFixed(1)} / $waterGoal L",
                        style: const TextStyle(color: Colors.white, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text("Last time 10:45 AM",
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        currentWater = (currentWater + step).clamp(0.0, waterGoal);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                    onPressed: () {
                      setState(() {
                        currentWater = (currentWater - step).clamp(0.0, waterGoal);
                      });
                    },
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
                child: Text(
                  "$percentDisplay%",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
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
                Navigator.pushNamed(context, AppRoutes.mealEdit);
                fetchTodayMeals();
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...todayMeals.map((meal) {
          final time = TimeOfDay.fromDateTime(meal.timestamp);
          final formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
          return Column(
            children: [
              mealCard(meal.title, formattedTime, meal.totalCalories.round()),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
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
