import 'package:flutter/material.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

class TrainBookingPage extends StatelessWidget {
  final Map<String, dynamic> trainData;

  TrainBookingPage(this.trainData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Train Ticket'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Train: ${trainData['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Route: ${trainData['route']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Available Seats: ${trainData['available_seats']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Book Ticket'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
