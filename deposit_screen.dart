import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DepositScreen extends StatefulWidget {
  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _amountController = TextEditingController();
  final _utrController = TextEditingController();

  // अपना UPI ID या PhonePe नंबर यहाँ डालें
  final String myUpiId = "yourphonepe@ybl"; 

  Future<void> submitDepositRequest() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String utrNumber = _utrController.text.trim();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (amount <= 0 || utrNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कृपया सही राशि और UTR/Ref नंबर दर्ज करें!')),
      );
      return;
    }

    // एडमिन वेरिफिकेशन के लिए फायरबेस में डिपॉजिट रिक्वेस्ट सेव करना
    await FirebaseFirestore.instance.collection('deposits').add({
      'userId': userId,
      'amount': amount,
      'utrNumber': utrNumber,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('पेमेंट सबमिट हुआ'),
        content: Text('पेमेंट वेरीफाई होते ही आपके वॉलेट में पैसे जोड़ दिए जाएंगे।'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _amountController.clear();
              _utrController.clear();
            },
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('पैसे डिपॉजिट करें')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('PhonePe / GooglePay / Paytm UPI:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    SelectableText(myUpiId, style: TextStyle(fontSize: 18, color: Colors.blue)),
                    SizedBox(height: 5),
                    Text('(ऊपर दिए UPI पर पैसे भेजें और UTR नंबर नीचे डालें)', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'भेजी गई राशि (₹)'),
            ),
            TextField(
              controller: _utrController,
              decoration: InputDecoration(labelText: 'UTR / Transaction Ref No.'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitDepositRequest,
              child: Text('सबमिट करें'),
            ),
          ],
        ),
      ),
    );
  }
}
