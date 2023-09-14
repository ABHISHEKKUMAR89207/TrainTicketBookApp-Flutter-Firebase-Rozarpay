import 'package:flutter/material.dart';
import 'package:my_flutter_app/Bottom_NavigatorTrain.dart';

class CustomerSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Support',
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
                'Contact our customer support team for assistance.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the chatbot page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotPage(),
                  ),
                );
              },
              child: Text('Start Chat with Chatbot'),
            ),
            SizedBox(height: 20),
            HelpButton(
              label: 'FAQs',
              onPressed: () {
                // Navigate to the FAQs page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FAQsPage(),
                  ),
                );
              },
            ),
            HelpButton(
              label: 'Contact Us',
              onPressed: () {
                // Navigate to the contact page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}

class HelpButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  HelpButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class ChatbotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chatbot',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Chat with our AI-powered chatbot for assistance.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 209, 205, 205),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Contact Information',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
       bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
