import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

void addTrainData() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> trainData = {
    "train_id_1": {
      "name": "Rajdhani Express",
      "route": "Delhi to Mumbai",
      "departure_time": "08:00 AM",
      "arrival_time": "08:00 PM",
      "capacity": 300,
      "available_seats": 100,
    },
    "train_id_2": {
      "name": "Shatabdi Express",
      "route": "Kolkata to Delhi",
      "departure_time": "09:30 AM",
      "arrival_time": "06:30 PM",
      "capacity": 200,
      "available_seats": 50,
    },
  };

  trainData.forEach((trainId, data) {
    firestore.collection('trains').doc(trainId).set(data);
  });
}

class ADDTRAIN extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Train Management App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              addTrainData(); // Add train data when the button is pressed
            },
            child: Text('Add Train Data'),
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }
}
