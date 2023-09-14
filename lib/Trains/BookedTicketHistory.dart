import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';
import 'package:my_flutter_app/Trains/CanceledTicket.dart';

class TicketHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booked Ticket History',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: TicketList(),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CanceledTicketPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 203, 195, 32),
        ),
        child: Text('View Canceled Tickets'),
      ),
    );
  }
}

class TicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bookedTickets')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> tickets =
            snapshot.data!.docs;

        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> ticketData = tickets[index].data();
            String ticketId = tickets[index].id;
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text('Train ID: ${ticketData['trainId']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Passenger: ${ticketData['passengerName']}'),
                    Text('Journey Date: ${ticketData['_selectedDay']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Price: \$${ticketData['totalPrice']}'),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        bool confirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Cancellation'),
                              content: Text(
                                  'Are you sure you want to cancel this ticket?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // Confirmed
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // Not confirmed
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed == true) {
                          // Save the canceled ticket data with the current user's ID as document ID
                          Map<String, dynamic> ticketData =
                              tickets[index].data();

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('canceledTickets')
                              .add(ticketData);

                          // Delete the booked ticket (optional)
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('bookedTickets')
                              .doc(ticketId)
                              .delete();
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
