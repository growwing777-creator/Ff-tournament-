import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ffUidController = TextEditingController();

  Future<void> registerUser() async {
    try {
      // 1. Firebase Auth में यूज़र बनाना
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Firestore Database में यूज़र डिटेल्स + FF UID + ₹0 वॉलेट सेव करना
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'ffUid': _ffUidController.text.trim(),
        'walletBalance': 0.0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('रजिस्ट्रेशन सफल हुआ!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('एरर: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('रजिस्टर करें')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'नाम')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'ईमेल')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'पासवर्ड'), obscureText: true),
            TextField(controller: _ffUidController, decoration: InputDecoration(labelText: 'Free Fire UID')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('साइन अप'),
            ),
          ],
        ),
      ),
    );
  }
}
