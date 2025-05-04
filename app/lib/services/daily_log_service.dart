import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/daily_log_model.dart';

class DailyLogService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference get dailyLogs => firestore.collection('daily_logs');

  String? get userId => auth.currentUser?.uid;

  String generateLogId(DateTime date) {
    final formatted = "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
    return "${userId}_$formatted";
  }

  /// Create or update the daily log for a specific date
  Future<void> createOrUpdateLog(DailyMeal log) async {
    if (userId == null) return;
    final logId = generateLogId(log.mealTime);

    await dailyLogs.doc(logId).set(log.toMap(), SetOptions(merge: true));
  }

  /// Get all logs for the current user
  Future<List<DailyMeal>> getLogsForUser() async {
    if (userId == null) return [];

    final snapshot = await dailyLogs
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return DailyMeal.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  /// Delete a specific daily log
  Future<void> deleteLog(DateTime date) async {
    if (userId == null) return;
    final logId = generateLogId(date);
    await dailyLogs.doc(logId).delete();
  }

  /// Add a new meal to an existing daily log
  Future<void> addMealToLog({
    required DateTime date,
    required String mealId,
    required String mealName,
    required double mealCalories,
    required double mealProtein,
    required double mealCarbs,
    required double mealFat,
  }) async {
    if (userId == null) return;

    final logId = generateLogId(date);

    final mealEntry = {
      'mealId': mealId,
      'mealName': mealName,
      'mealCalories': mealCalories,
      'mealProtein': mealProtein,
      'mealCarbs': mealCarbs,
      'mealFat': mealFat,
      'mealTime': Timestamp.fromDate(DateTime.now()),
    };

    try {
      await dailyLogs.doc(logId).update({
        'meals': FieldValue.arrayUnion([mealEntry]),
      });
    } catch (e) {
      throw Exception("Failed to add meal to log: $e");
    }
  }
}
