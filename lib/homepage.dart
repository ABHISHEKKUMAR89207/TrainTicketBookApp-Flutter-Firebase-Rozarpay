import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';
import 'package:my_flutter_app/Drawe.dart';
import 'package:my_flutter_app/Trains/BookedTicketHistory.dart';
import 'package:my_flutter_app/Trains/SearchTrain.dart';
import 'package:my_flutter_app/Trains/checkoffers.dart';
import 'package:my_flutter_app/Trains/customer%20support.dart';
import 'package:my_flutter_app/views/SignInScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> carouselImages = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
  ];
  final List<String> carouselImages2 = [
    'assets/4.jpg',
    'assets/5.jpg',
    'assets/6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Train Ticket Booking',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 8, 83, 112),
          actions: [
            GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Get.to(() => LogineScreen());
                },
                child: Icon(Icons.logout))
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color.fromARGB(255, 209, 205, 205),
          child: ListView(
            children: [
              Container(
                height: 200,
                child: CarouselSlider(
                  items: carouselImages.map((imagePath) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.train,
                          size: 60,
                          color: const Color.fromARGB(255, 6, 65, 113)),
                      onPressed: () {
                        // Navigate to train search page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainSearchPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.history,
                          size: 60, color: Color.fromARGB(255, 135, 76, 4)),
                      onPressed: () {
                        // Navigate to booking history page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketHistoryPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainSearchPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Book Tickets',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OffersPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      child: Text(
                        'Check Offers',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerSupportPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(
                        'Customer Support',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                height: 200,
                child: CarouselSlider(
                  items: carouselImages2.map((imagePath) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }
}
