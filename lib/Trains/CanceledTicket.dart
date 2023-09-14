import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

class CanceledTicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canceled Ticket History',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: CanceledTicketList(),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}

class CanceledTicketList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Center(
        child: Text('Please log in to view canceled tickets.'),
      );
    }
    String userId = currentUser.uid;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('canceledTickets')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<QueryDocumentSnapshot<Map<String, dynamic>>> canceledTickets =
            snapshot.data!.docs;

        if (canceledTickets.isEmpty) {
          // Handle the case where there are no canceled tickets
          return Center(
            child: Text('No canceled tickets found.'),
          );
        }

        return ListView.builder(
          itemCount: canceledTickets.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> ticketData = canceledTickets[index].data();
            String ticketId = canceledTickets[index].id;
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
              ),
            );
          },
        );
      },
    );
  }
}
