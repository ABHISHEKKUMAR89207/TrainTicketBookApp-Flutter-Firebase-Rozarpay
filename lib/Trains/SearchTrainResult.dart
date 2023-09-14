import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';
import 'package:my_flutter_app/Trains/AddPassengerInfo.dart';

class TrainResultsPage extends StatefulWidget {
  final String startStation;
  final String endStation;
  final String _selectedDay;
  final String _selectedDate;

  TrainResultsPage(this.startStation, this.endStation, this._selectedDay, this._selectedDate);

  @override
  _TrainResultsPageState createState() => _TrainResultsPageState();
}
class _TrainResultsPageState extends State<TrainResultsPage> {
  List<QueryDocumentSnapshot> _trainResults = [];

  @override
  void initState() {
    super.initState();
    _fetchTrains();
  }

  void _fetchTrains() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trains')
        .where('route', isEqualTo: '${widget.startStation} to ${widget.endStation}')
        .get();

    setState(() {
      _trainResults = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Train Results',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_trainResults.isEmpty)
                Center(
                  child: Text(
                    'No trains available for the selected criteria.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _trainResults.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot trainData = _trainResults[index];
                  Map<String, dynamic> data = trainData.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassengerInfoPage(trainData, widget._selectedDay, widget._selectedDate),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 123, 150, 157),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons.train, color: Color.fromARGB(255, 113, 39, 137)),
                        title: Text(
                          data['name'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['route'],
                          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 163, 21, 45)),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Seats: ${data['available_seats']}',
                              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 39, 199, 130)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ), bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
