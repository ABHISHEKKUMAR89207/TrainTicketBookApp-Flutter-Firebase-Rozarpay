import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';
import 'package:my_flutter_app/Trains/BookedTicketHistory.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PassengerInfoPage extends StatefulWidget {
  final DocumentSnapshot trainData;
  final String _selectedDay;
  final String _selectedDate;

  PassengerInfoPage(this.trainData, this._selectedDay, this._selectedDate);

  @override
  _PassengerInfoPageState createState() => _PassengerInfoPageState();
}

class _PassengerInfoPageState extends State<PassengerInfoPage> {
  List<Passenger> _passengers = [Passenger()];
  double _price = 0;
  double _totalPrice = 0;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _fetchPrice();
    _updateTotalPrice();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet payment: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _fetchPrice() {
    _price = widget.trainData['Price'];
  }

  void _updateTotalPrice() {
    int totalPassengers = _passengers.length;
    setState(() {
      _totalPrice = totalPassengers * _price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
        title: Text('Booking Informatio',
            style: TextStyle(
                fontSize: 25, color: Color.fromARGB(255, 235, 232, 235))),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int index = 0; index < _passengers.length; index++)
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 175, 203, 209),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.person, color: Colors.blue),
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                _passengers.removeAt(index);
                                _updateTotalPrice();
                              });
                            },
                          ),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Passenger Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _passengers[index].name = value,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Age',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) =>
                            _passengers[index].age = int.tryParse(value) ?? 0,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nationality',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            _passengers[index].nationality = value,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _passengers[index].id = value,
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _passengers.add(Passenger());
                    _updateTotalPrice();
                  });
                },
                child: Text('Add Passenger',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 16),
              Text(
                'Total Price: \$$_totalPrice',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 109, 199, 112),
                ),
                onPressed: () {
                  var options = {
                    'key':
                        'your api key', // Replace with your Razorpay API key
                    'amount': (_totalPrice * 100)
                        .toInt(), // Amount in paise (multiply by 100)
                    'name': 'Your App Name',
                    'description': 'Payment for train booking',
                    'prefill': {
                      'contact': 'YOUR_CONTACT_NUMBER',
                      'email': 'YOUR_EMAIL',
                    },
                  };

                  try {
                    _razorpay.open(options);
                  } catch (e) {
                    print("Error initiating payment: $e");
                  }
                  _confirmBooking();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketHistoryPage()),
                  );
                },
                child: Text('Pay Now',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }

  void _confirmBooking() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    String userId = currentUser.uid;

    int availableSeats =
        widget.trainData['available_seats'] - _passengers.length;
    await widget.trainData.reference.update({
      'available_seats': availableSeats,
    });

    for (var passenger in _passengers) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bookedTickets')
          .add({
        'trainId': widget.trainData['trainId'],
        'passengerName': passenger.name,
        'age': passenger.age,
        'nationality': passenger.nationality,
        'id': passenger.id,
        'totalPrice': _totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
        '_selectedDay': "${widget._selectedDay} on ${widget._selectedDate}",
      });
    }

    Navigator.pop(context);
  }
}

class Passenger {
  String name = '';
  int age = 0;
  String nationality = '';
  String id = '';
}
