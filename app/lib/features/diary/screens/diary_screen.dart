import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../shared/models/meal_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../routes/routes.dart';
import 'meal_edit_screen.dart';

class DiaryScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const DiaryScreen({super.key, this.selectedDate});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  double currentWater = 0;
  final double waterGoal = 2.5;
  final double step = 0.2;
  String? lastWaterUpdateTime;

  List<Meal> todayMeals = [];
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;

  UserModel? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfileAndMeals();
  }

  String _getWaterDocId(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadWaterForDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docId = _getWaterDocId(_targetDate);
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('water_logs')
            .doc(docId)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        currentWater = (data['amount'] as num?)?.toDouble() ?? 0;
        if (data['lastUpdated'] != null) {
          final timestamp = (data['lastUpdated'] as Timestamp).toDate();
          lastWaterUpdateTime =
              '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
        }
      });
    } else {
      setState(() {
        currentWater = 0;
        lastWaterUpdateTime = null;
      });
    }
  }

  Future<void> saveWaterIntake(double amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docId = _getWaterDocId(_targetDate);
    final now = DateTime.now();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('water_logs')
        .doc(docId)
        .set({
          'amount': amount,
          'lastUpdated': Timestamp.fromDate(now),
          'date': Timestamp.fromDate(_targetDate),
        });

    setState(() {
      currentWater = amount;
      lastWaterUpdateTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> loadUserProfileAndMeals() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      // Fetch user profile
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists && userDoc.data() != null) {
        userProfile = UserModel.fromMap(user.uid, userDoc.data()!);
      }

      await fetchMealsForDate();
      await loadWaterForDate();
    } catch (e) {
      debugPrint('Error loading user profile and meals: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  DateTime get _targetDate => widget.selectedDate ?? DateTime.now();

  Future<void> fetchMealsForDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final date = _targetDate;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot =
        await FirebaseFirestore.instance
            .collection('meals')
            .where('userId', isEqualTo: userId)
            .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
            .where('timestamp', isLessThan: endOfDay)
            .get();

    final meals =
        snapshot.docs.map((doc) => Meal.fromMap(doc.data(), doc.id)).toList();

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
  void didUpdateWidget(DiaryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload meals and water when selectedDate changes
    if (widget.selectedDate != oldWidget.selectedDate) {
      fetchMealsForDate();
      loadWaterForDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            buildNutrientsIndicator(),
            const SizedBox(height: 24),
            buildWaterIntake(),
            const SizedBox(height: 24),
            buildMealsSection(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildNutrientsIndicator() {
    // Use calculated goals if user profile exists, otherwise use defaults
    final calorieGoal = userProfile?.dailyCalorieGoal ?? 2700;
    final proteinGoal = userProfile?.proteinGoal ?? 225;
    final fatGoal = userProfile?.fatGoal ?? 118;
    final carbGoal = userProfile?.carbGoal ?? 340;

    final calorieProgress = (totalCalories / calorieGoal).clamp(0.0, 1.0);
    final remainingCalories = (calorieGoal - totalCalories).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Nutrition",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color:
                    remainingCalories > 0
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                remainingCalories > 0
                    ? "$remainingCalories cal left"
                    : "${-remainingCalories} cal over",
                style: TextStyle(
                  color:
                      remainingCalories > 0
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade800, Colors.indigo.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Calorie Circle
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: calorieProgress,
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: Colors.tealAccent,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${totalCalories.round()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "/ ${calorieGoal.round()}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMacroRow(
                          "Protein",
                          totalProtein,
                          proteinGoal,
                          Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        _buildMacroRow(
                          "Carbs",
                          totalCarbs,
                          carbGoal,
                          Colors.tealAccent,
                        ),
                        const SizedBox(height: 12),
                        _buildMacroRow(
                          "Fat",
                          totalFat,
                          fatGoal,
                          Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroRow(String label, double value, double goal, Color color) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Text(
              "${value.round()}g / ${goal.round()}g",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.2),
            color: color,
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
    double percentage = (currentWater / waterGoal).clamp(0.0, 1.5);
    int percentDisplay = (percentage * 100).round();
    bool overGoal = currentWater > waterGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Water Intake",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Water drop icon with percentage
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: overGoal ? Colors.greenAccent : Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$percentDisplay%",
                      style: TextStyle(
                        color: overGoal ? Colors.greenAccent : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${currentWater.toStringAsFixed(1)}L",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " / ${waterGoal}L",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastWaterUpdateTime != null
                          ? "Last updated at $lastWaterUpdateTime"
                          : "Tap + to start tracking",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        color: overGoal ? Colors.greenAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  _waterButton(Icons.add, () {
                    final newAmount = currentWater + step;
                    setState(() => currentWater = newAmount);
                    saveWaterIntake(newAmount);
                  }),
                  const SizedBox(height: 8),
                  _waterButton(Icons.remove, () {
                    final newAmount = (currentWater - step).clamp(
                      0.0,
                      double.infinity,
                    );
                    setState(() => currentWater = newAmount);
                    saveWaterIntake(newAmount);
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _waterButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget buildMealsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Today's Meals",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MealEditScreen(selectedDate: _targetDate),
                  ),
                );
                fetchMealsForDate();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (todayMeals.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.restaurant_menu, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No meals logged yet',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap Add to log your first meal',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          )
        else
          ...todayMeals.map((meal) {
            final time = TimeOfDay.fromDateTime(meal.timestamp);
            final formattedTime =
                "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: mealCard(
                meal.title,
                formattedTime,
                meal.totalCalories.round(),
                meal.totalProtein,
                meal.totalCarbs,
                meal.totalFat,
              ),
            );
          }),
      ],
    );
  }

  Widget mealCard(
    String title,
    String time,
    int calories,
    double protein,
    double carbs,
    double fat,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.orange.shade400,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    _macroChip(
                      "P",
                      protein.round(),
                      Colors.red.shade100,
                      Colors.red.shade700,
                    ),
                    const SizedBox(width: 6),
                    _macroChip(
                      "C",
                      carbs.round(),
                      Colors.teal.shade100,
                      Colors.teal.shade700,
                    ),
                    const SizedBox(width: 6),
                    _macroChip(
                      "F",
                      fat.round(),
                      Colors.orange.shade100,
                      Colors.orange.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$calories",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "cal",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroChip(String label, int value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "$label:$value",
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
