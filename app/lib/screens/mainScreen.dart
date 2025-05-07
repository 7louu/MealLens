import 'package:flutter/material.dart';
import 'diaryScreen.dart';
import 'lensScreen.dart';
import 'reportScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens =  [
    const DiaryScreen(),
    const LensScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const SizedBox(width: 4),
            const Text(
              'Belkahla',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        actions: [
          if (selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(data: ThemeData.dark(), child: child!);
                  },
                );
              },
            ),
        ],
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Diary"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Lens"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
        ],
      ),
    );
  }
}
