import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

// Dashboard orang tua untuk melihat identitas dan nilai skill pemain.
class ParentDashboard extends StatelessWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Orang Tua & Pemain'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Data ditampilkan langsung dari stream koleksi pemain Firestore.
        stream: FirebaseFirestore.instance.collection('players').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Kelompok Usia: ${data['ageGroup']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 20),
                      _scoreRow('Passing', data['passing']),
                      _scoreRow('Controlling', data['controlling']),
                      _scoreRow('Dribbling', data['dribbling']),
                      _scoreRow('Heading', data['heading']),
                      _scoreRow('Shooting', data['shooting']),
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

  // Mengubah nilai 0-100 menjadi teks dan progress bar.
  Widget _scoreRow(String label, dynamic value) {
    double score = (value ?? 0.0).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 8,
              ),
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
