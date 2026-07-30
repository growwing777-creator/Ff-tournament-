// main.dart - सब स्क्रीन्स को आपस में जोड़ने वाला कोड
import 'package:flutter/material.dart';

void main() => runApp(FreeFireApp());

class FreeFireApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FF Tournament App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Free Fire Tournament')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentScreen())),
              child: Text('टूर्नामेंट देखें व जॉइन करें'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DepositScreen())),
              child: Text('पैसे ऐड करें (Deposit)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawScreen(currentBalance: 100))),
              child: Text('पैसे निकालें (Withdraw)'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanelScreen())),
              child: Text('एडमिन पैनल (केवल आपके लिए)'),
            ),
          ],
        ),
      ),
    );
  }
}
