import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Profile/ProfileSettings.dart';
import 'package:my_flutter_app/Trains/BokkTicketPage.dart';
import 'package:my_flutter_app/Trains/BookedTicketHistory.dart';
import 'package:my_flutter_app/Trains/CanceledTicket.dart';
import 'package:my_flutter_app/Trains/SearchTrain.dart';
import 'package:my_flutter_app/homepage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getUserData(String userId) async {
  try {
    final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return {'username': 'User not found', 'userEmail': 'N/A'};
    }
  } catch (error) {
    print('Error fetching user data: $error');
    return {'username': 'Error', 'userEmail': 'N/A'};
  }
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User? userId = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic> data = await getUserData(currentUser.uid);
      setState(() {
        userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 209, 205, 205),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  '${userData['username'] ?? 'Loading...'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  'User Email: ${userData['userEmail'] ?? 'Loading...'}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 83, 112),
                ),
              ),
            ),
            _buildDrawerItem(Icons.person, 'Profile', ProfileScreen()),
            _buildDrawerItem(Icons.home, 'Home', HomePage()),
            _buildDrawerItem(
                Icons.history, 'Booking History', TicketHistoryPage()),
            _buildDrawerItem(
                Icons.cancel, 'Canceled Ticket', CanceledTicketPage()),
            _buildDrawerItem(Icons.train, 'Book NOw', TrainSearchPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
