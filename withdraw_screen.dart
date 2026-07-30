import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WithdrawScreen extends StatefulWidget {
  final double currentBalance;
  WithdrawScreen({required this.currentBalance});

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _amountController = TextEditingController();
  final _upiController = TextEditingController();

  Future<void> requestWithdrawal() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (amount <= 0 || amount > widget.currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('अमान्य राशि! पर्याप्त बैलेंस नहीं है।')),
      );
      return;
    }

    // Firestore में विथड्रॉल रिक्वेस्ट भेजना (एडमिन पैनल के लिए)
    await FirebaseFirestore.instance.collection('withdrawals').add({
      'userId': userId,
      'upiId': _upiController.text.trim(),
      'amount': amount,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // यूज़र को 24 घंटे वाला मैसेज दिखाना
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('रिक्वेस्ट भेजी गई'),
        content: Text('आपका पैसा 24 घंटे में आपके खाते में आ जाएगा।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('विथड्रॉल करें')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('आपका बैलेंस: ₹${widget.currentBalance}'),
            TextField(controller: _amountController, decoration: InputDecoration(labelText: 'रुपये दर्ज करें')),
            TextField(controller: _upiController, decoration: InputDecoration(labelText: 'UPI ID दर्ज करें')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: requestWithdrawal,
              child: Text('विथड्रॉ करें'),
            ),
          ],
        ),
      ),
    );
  }
}
