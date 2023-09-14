import 'package:flutter/material.dart';
import 'package:my_flutter_app/Profile/ProfileSettings.dart';
import 'package:my_flutter_app/Trains/BookedTicketHistory.dart';
import 'package:my_flutter_app/Trains/SearchTrain.dart';
import 'package:my_flutter_app/homepage.dart';

class BottomNavigatorExample extends StatefulWidget {
  @override
  _BottomNavigatorExampleState createState() => _BottomNavigatorExampleState();
}

class _BottomNavigatorExampleState extends State<BottomNavigatorExample> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color.fromARGB(255, 8, 83, 112),
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                size: 40, color: Color.fromARGB(255, 240, 236, 231)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train_outlined,
                size: 40, color: Color.fromARGB(255, 240, 236, 231)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off,
                size: 40, color: Color.fromARGB(255, 240, 236, 231)),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                size: 40, color: Color.fromARGB(255, 240, 236, 231)),
            label: 'Person',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainSearchPage(),
                ));
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketHistoryPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}
