import 'package:flutter/material.dart';

import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

class OffersPage extends StatefulWidget {
  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final List<String> offers = [
    '50% off on selected routes!',
    'Special discount for group bookings!',
    'Free meal on board for limited time!',
    'Weekend getaway offers available!',
    'Kids travel free this month!',
  ];

  String getRandomOffer() {
    return offers[DateTime.now().millisecondsSinceEpoch % offers.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Offers',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Explore our latest offers and discounts!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Random Offer'),
                      content: Text(getRandomOffer()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Get Random Offer'),
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OffersPage(),
  ));
}
