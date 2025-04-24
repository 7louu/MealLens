import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyLogService {

  final CollectionReference dailyLogCollection = FirebaseFirestore.instance.collection('daily_logs'); 
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  String generateLogId(DateTime date) {
    final formattedDate = "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
    return "${userId}_$formattedDate";
  }

  Future<void> createOrUpdateLog ({
    required DateTime date,
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
    required List<String> meals,
    }) async {
      if (userId == null) return;

      final logId = generateLogId(date);

      final logData = {
        'userId': userId,
        'date': Timestamp.fromDate(date),
        'totalCalories': totalCalories,
        'totalProtein': totalProtein,
        'totalCarbs': totalCarbs,
        'totalFat': totalFat,
        'meals': meals,
      };

      await dailyLogCollection.doc(logId).set(logData, SetOptions(merge: true));
    }

  Future<List<Map<String, dynamic>>> getLogsForUser() async {
    if (userId == null) return [];

    final querySnapshot = await dailyLogCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> deleteLog (DateTime date) async {
    if (userId == null) return;

    final logId = generateLogId(date);
    await dailyLogCollection.doc(logId).delete();
  }

  Future<void> addMealtoLog ({
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

    final mealData = {
      'mealId': mealId,
      'mealName': mealName,
      'mealCalories': mealCalories,
      'mealProtein': mealProtein,
      'mealCarbs': mealCarbs,
      'mealFat': mealFat,
      'mealTime': Timestamp.fromDate(DateTime.now()),
    };

    try {
      await dailyLogCollection.doc(logId).update({
        'meals': FieldValue.arrayUnion([mealData]),
      });
    } catch (e) {
      throw Exception("Failed to add meal to log: $e");
    }

  }
}