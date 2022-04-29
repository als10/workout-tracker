import 'package:flutter/material.dart';
import 'package:workout_tracker/screens/StatisticsPage.dart';
import 'package:workout_tracker/screens/WorkoutsList/WorkoutsList.dart';

int HISTORY_PAGE = 0;
int STATISTICS_PAGE = 1;

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentPage;

  @override
  void initState() {
    currentPage = HISTORY_PAGE;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage == HISTORY_PAGE
        ? WorkoutsList()
        : StatisticsPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Statistics',
          ),
        ],
        currentIndex: currentPage,
        onTap: (index) => setState(() => currentPage = index),
      ),
    );
  }
}

