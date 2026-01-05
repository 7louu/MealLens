import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightEntry {
  final String? id;
  final DateTime date;
  final double weight;

  WeightEntry(this.date, this.weight, {this.id});
}

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  List<WeightEntry> weightEntries = [];
  bool isLoading = true;

  final TextEditingController weightController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadWeightEntries();
  }

  Future<void> loadWeightEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weight_logs')
        .orderBy('date', descending: false)
        .get();

    final entries = snapshot.docs.map((doc) {
      final data = doc.data();
      return WeightEntry(
        (data['date'] as Timestamp).toDate(),
        (data['weight'] as num).toDouble(),
        id: doc.id,
      );
    }).toList();

    setState(() {
      weightEntries = entries;
      isLoading = false;
    });
  }

  Future<void> saveWeightEntry(DateTime date, double weight) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('weight_logs')
        .add({
      'date': Timestamp.fromDate(date),
      'weight': weight,
      'createdAt': Timestamp.now(),
    });

    setState(() {
      weightEntries.add(WeightEntry(date, weight, id: docRef.id));
      weightEntries.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  void showAddWeightDialog() {
    selectedDate = null;
    weightController.clear();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Add Weight"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: "Enter your weight (kg)"),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "No date chosen"
                          : DateFormat('MMM d, yyyy').format(selectedDate!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? now,
                        firstDate: DateTime(2000),
                        lastDate: now,
                      );
                      if (pickedDate != null) {
                        setStateDialog(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Choose Date"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredWeight = double.tryParse(weightController.text);
                if (enteredWeight != null && selectedDate != null) {
                  saveWeightEntry(selectedDate!, enteredWeight);
                  weightController.clear();
                  Navigator.pop(context);
                } else {
                  // Show error if weight or date not entered
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter weight and choose a date')),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
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
            ...weightEntries.reversed.map(buildResultCard),
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
    if (weightEntries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        height: 200,
        alignment: Alignment.center,
        child: const Text(
          'No weight data yet.\nTap + to add your first entry.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      );
    }
    
    final sortedEntries = List<WeightEntry>.from(weightEntries)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<FlSpot> spots = sortedEntries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weight);
    }).toList();
    
    // Calculate dynamic Y bounds
    final weights = sortedEntries.map((e) => e.weight).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final padding = (maxWeight - minWeight) * 0.2;
    final chartMinY = (minWeight - padding - 5).clamp(0.0, double.infinity);
    final chartMaxY = maxWeight + padding + 5;

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
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Hide X axis labels
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          minY: chartMinY,
          maxY: chartMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
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
