import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String profilePictureUrl = ''; // Store the profile picture URL

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (userDoc.exists) {
        setState(() {
          nameController.text = userDoc['username'] ?? '';
          emailController.text = userDoc['userEmail'] ?? '';
          phoneController.text = userDoc['userPhone'] ?? '';
          addressController.text = userDoc['Address'] ?? '';
          // Fetch profile picture URL
        });
      }
    }
  }

  void _updateField(String fieldName, String newValue) async {
    if (currentUser != null) {
      try {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          fieldName: newValue,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$fieldName updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating $fieldName: $e')),
        );
      }
    }
  }

  Future<void> _showEditDialog(
      String fieldName, TextEditingController controller) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $fieldName'),
          content: TextField(
            controller: controller,
            style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                _updateField(fieldName, controller.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: profilePictureUrl.isNotEmpty
                    ? Image.network(
                        profilePictureUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/profile.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 16),
            _buildFieldRow('username', nameController),
            _buildFieldRow('userEmail', emailController),
            _buildFieldRow('userPhone', phoneController),
            _buildFieldRow('Address', addressController),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }

  Widget _buildFieldRow(String fieldName, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            fieldName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Row(
            children: [
              Text(
                controller.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                onPressed: () {
                  _showEditDialog(fieldName, controller);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
