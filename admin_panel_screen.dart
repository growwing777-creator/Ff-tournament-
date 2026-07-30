import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _matchTitleController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _prizePoolController = TextEditingController();
  final _matchTimeController = TextEditingController();

  // 1. नया मैच जोड़ना
  Future<void> addMatch() async {
    if (_matchTitleController.text.isEmpty) return;

    await FirebaseFirestore.instance.collection('tournaments').add({
      'title': _matchTitleController.text.trim(),
      'entryFee': double.tryParse(_entryFeeController.text) ?? 0.0,
      'prizePool': double.tryParse(_prizePoolController.text) ?? 0.0,
      'time': _matchTimeController.text.trim(),
      'roomId': null,
      'roomPassword': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _matchTitleController.clear();
    _entryFeeController.clear();
    _prizePoolController.clear();
    _matchTimeController.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('नया मैच ऐड हो गया!')));
  }

  // 2. मैच में Room ID और Password डालना
  Future<void> updateRoomDetails(String matchId, String roomId, String password) async {
    await FirebaseFirestore.instance.collection('tournaments').doc(matchId).update({
      'roomId': roomId,
      'roomPassword': password,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room ID अपडेट हो गई!')));
  }

  // 3. डिपॉजिट अप्रूव करके यूज़र का बैलेंस बढ़ाना
  Future<void> approveDeposit(String depositId, String userId, double amount) async {
    // यूज़र के वॉलेट में पैसे ऐड करना
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'walletBalance': FieldValue.increment(amount),
    });

    // डिपॉजिट स्टेटस कंप्लीट करना
    await FirebaseFirestore.instance.collection('deposits').doc(depositId).update({
      'status': 'Approved',
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('डिपॉजिट अप्रूव हुआ, बैलेंस बढ़ गया!')));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('एडमिन पैनल Control'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'मैच व Room ID'),
              Tab(text: 'डिपॉजिट अप्रूवल'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // टैब 1: नया मैच बनाना
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('नया टूर्नामेंट जोड़ें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(controller: _matchTitleController, decoration: InputDecoration(labelText: 'मैच टाइटल (e.g. Solo Match #1)')),
                    TextField(controller: _entryFeeController, decoration: InputDecoration(labelText: 'एंट्री फीस (₹)')),
                    TextField(controller: _prizePoolController, decoration: InputDecoration(labelText: 'प्राइज पूल (₹)')),
                    TextField(controller: _matchTimeController, decoration: InputDecoration(labelText: 'समय (e.g. 5:00 PM)')),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: addMatch, child: Text('मैच पब्लिश करें')),
                  ],
                ),
              ),
            ),

            // टैब 2: यूज़र के डिपॉजिट अप्रूव करना
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('deposits').where('status', isEqualTo: 'Pending').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                var deposits = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: deposits.length,
                  itemBuilder: (context, index) {
                    var dep = deposits[index];
                    return Card(
                      child: ListTile(
                        title: Text('राशि: ₹${dep['amount']}'),
                        subtitle: Text('UTR: ${dep['utrNumber']}'),
                        trailing: ElevatedButton(
                          onPressed: () => approveDeposit(dep.id, dep['userId'], dep['amount'].toDouble()),
                          child: Text('OK (पैसे ऐड करें)'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
