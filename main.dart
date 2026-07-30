import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import all your created screens here
// import 'user_model.dart';
// import 'register_screen.dart';
// import 'tournament_screen.dart';
// import 'deposit_screen.dart';
// import 'withdraw_screen.dart';
// import 'admin_panel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase Connect
  runApp(FreeFireApp());
}

class FreeFireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FF Tournament App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Fire Esports'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.sports_esports),
              label: Text('टूर्नामेंट लिस्ट व Room ID'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentScreen()));
              },
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              icon: Icon(Icons.account_balance_wallet),
              label: Text('पैसे डिपॉजिट करें (PhonePe)'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DepositScreen()));
              },
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              icon: Icon(Icons.money_off),
              label: Text('पैसे निकालें (Withdrawal)'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawScreen(currentBalance: 0)));
              },
            ),
            SizedBox(height: 30),
            Divider(thickness: 2),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              icon: Icon(Icons.admin_panel_settings),
              label: Text('एडमिन पैनल (Admin Only)', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanelScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
