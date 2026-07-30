import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Free Fire टूर्नामेंट्स')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tournaments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var matches = snapshot.data!.docs;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              var match = matches[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(match['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('एंट्री फीस: ₹${match['entryFee']} | प्राइज पूल: ₹${match['prizePool']}'),
                      Text('समय: ${match['time']}'),
                      Divider(),
                      // केवल एडमिन द्वारा डाली गई Room ID यहाँ दिखेगी
                      Text('Room ID: ${match['roomId'] ?? "मैच से 15 मिनट पहले मिलेगी"}', 
                           style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      Text('Password: ${match['roomPassword'] ?? "***"}'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // मैच जॉइन करने का लॉजिक
                        },
                        child: Text('जॉइन करें'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
