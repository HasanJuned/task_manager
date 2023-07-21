import 'package:flutter/material.dart';
import 'package:softbyhasan/ui/screens/Inprogress-task-screen.dart';
import 'package:softbyhasan/ui/screens/cancelled-task-screen.dart';
import 'package:softbyhasan/ui/screens/completed-task-screen.dart';
import 'package:softbyhasan/ui/screens/new-task-screen.dart';

import '../widgets/user-profile-widget.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {

  int _selectedScreen = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    InprogressTaskScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UserProfileWidget(),
              Expanded(child: _screens[_selectedScreen])

            ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black38,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: (index){
          _selectedScreen = index;
          setState(() {});
        },
        currentIndex: _selectedScreen,
        elevation: 4,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_label),
              label: 'New',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
          BottomNavigationBarItem(icon: Icon(Icons.downloading), label: 'Progress'),
        ],
      ),


    );
  }
}

