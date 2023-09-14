import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void addStationData() {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> stationData = {
    "station_id_1": {
      "name": "New Delhi",
      "location": "28.6139° N, 77.2090° E",
    },
    "station_id_2": {
      "name": "Agra",
      "location": "27.1767° N, 78.0081° E",
    },
    "station_id_3": {
      "name": "Jaipur",
      "location": "26.9124° N, 75.7873° E",
    },
    "station_id_4": {
      "name": "Vadodara",
      "location": "22.3072° N, 73.1812° E",
    },
    "station_id_5": {
      "name": "Mumbai",
      "location": "19.0760° N, 72.8777° E",
    },
    "station_id_6": {
      "name": "Kolkata",
      "location": "22.5726° N, 88.3639° E",
    },
    // ... More station entries
  };

  stationData.forEach((stationId, data) {
    firestore.collection('stations').doc(stationId).set(data);
  });
}


class ADDSTATION extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Station Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Station Management App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              addStationData();
            },
            child: Text('Add Station Data'),
          ),
        ),
      ),
    );
  }
}
