import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';
import 'package:my_flutter_app/Trains/SearchTrainResult.dart';

class TrainSearchPage extends StatefulWidget {
  @override
  _TrainSearchPageState createState() => _TrainSearchPageState();
}

class _TrainSearchPageState extends State<TrainSearchPage> {
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  DateTime? _selectedDate;
  late String _selectedDay;

  List<String> stationNames = [
    'New Delhi',
    'Delhi',
    'Jaipur',
    'Vadodara',
    'Mumbai',
    'Kolkata',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedDay = _getDayOfWeek(picked.weekday);
      });
    }
  }

  String _getDayOfWeek(int day) {
    switch (day + 1) {
      case 1:
        return 'Sunday';
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thursday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  void _searchTrains(BuildContext context) {
    String startStation = _startController.text;
    String endStation = _endController.text;

    if (startStation.isNotEmpty &&
        endStation.isNotEmpty &&
        _selectedDay != null) {
      if (stationNames.contains(startStation) &&
          stationNames.contains(endStation)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainResultsPage(startStation, endStation,
                _selectedDay, _selectedDate.toString()),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Station'),
              content: Text('Please select stations from the provided list.'),
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
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please select both stations and a journey date.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
        title: Text('Train Search',
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 235, 232, 235))),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _startController,
                  decoration: InputDecoration(
                    labelText: 'Start Station',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    prefixIcon: Icon(Icons.train),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return stationNames.where((station) =>
                      station.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _startController.text = suggestion;
                },
              ),
              SizedBox(height: 16.0),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _endController,
                  decoration: InputDecoration(
                    labelText: 'End Station',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    prefixIcon: Icon(Icons.train),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return stationNames.where((station) =>
                      station.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _endController.text = suggestion;
                },
              ),
              SizedBox(height: 16.0),
              Column(
                children: [
                  Text('Select Selected',
                      style: TextStyle(
                          fontSize: 19, color: Color.fromARGB(255, 31, 9, 31))),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                  SizedBox(width: 20),
                  _selectedDate != null
                      ? Text('Selected Date: ${_selectedDate?.toLocal()}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 21, 139, 40)))
                      : Text('No Date Selected'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _searchTrains(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5.0,
                ),
                child: Text(
                  'Search Trains',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
