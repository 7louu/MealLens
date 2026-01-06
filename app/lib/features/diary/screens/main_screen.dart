import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../routes/routes.dart';
import '../../auth/services/auth_service.dart';

import 'diary_screen.dart';
import '../../lens/screens/lens_screen.dart';
import '../../reports/screens/report_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 1;
  String? userName;
  String? userPhotoUrl;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (doc.exists && mounted) {
        setState(() {
          userName = doc.data()?['name'] ?? 'User';
          userPhotoUrl = doc.data()?['photoUrl'];
        });
      }
    }
  }

  String _getDateLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (selected == today) {
      return 'Today';
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    }
  }

  List<Widget> get screens => [
    LensScreen(selectedDate: selectedDate),
    DiaryScreen(selectedDate: selectedDate),
    const ReportsScreen(),
  ];

  void _showLogoutMenu(BuildContext context, Offset offset) async {
    final selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: [const PopupMenuItem<int>(value: 0, child: Text("Log out"))],
    );

    if (selected == 0) {
      await AuthService().signOutEmail();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.welcome,
        ); // Ensure '/home' route is defined
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Top Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
            child: Row(
              children: [
                GestureDetector(
                  onTapDown: (details) {
                    _showLogoutMenu(context, details.globalPosition);
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        userPhotoUrl != null && userPhotoUrl!.isNotEmpty
                            ? NetworkImage(userPhotoUrl!)
                            : const AssetImage(
                                  'assets/images/default_avatar.png',
                                )
                                as ImageProvider,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  userName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      _getDateLabel(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today, size: 20),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2022),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light(),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body content
          Expanded(child: screens[selectedIndex]),

          // Custom Bottom NavBar
          Container(
            margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.camera_alt, label: 'Lens', index: 0),
                _buildNavItem(
                  icon: Icons.book,
                  label: 'Diary',
                  index: 1,
                  isCenter: true,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart,
                  label: 'Reports',
                  index: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: isCenter ? 16 : 8,
        ),
        decoration:
            isSelected
                ? BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                )
                : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.green : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.green : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
