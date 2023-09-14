// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:my_flutter_app/Trains/BookedTicketHistory.dart';
import 'package:my_flutter_app/Trains/SearchTrain.dart';
import 'package:my_flutter_app/Trains/Updatestations.dart';
import 'package:my_flutter_app/Trains/Updatetraindata.dart';
import 'package:my_flutter_app/homepage.dart';

import 'package:my_flutter_app/views/SignInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: user != null ? HomePage() : const LogineScreen(),
      routes: {
        '/page1': (context) => ADDTRAIN(),
        '/page2': (context) => ADDSTATION(),
        '/page3': (context) => TrainSearchPage(),
        '/page0': (context) => TicketHistoryPage(),
      },
    );
  }
}
