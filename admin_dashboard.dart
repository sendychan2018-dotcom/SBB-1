import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

// Dashboard admin untuk mengelola daftar pemain di Firestore.
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  // Meminta nama dan kelompok usia sebelum membuat dokumen pemain baru.
  void _showAddPlayerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Siswa / Pemain Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap Pemain',
              ),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Kelompok Usia (Cth: U-12)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                // Nilai skill dimulai dari nol dan waktu dibuat diisi server.
                await FirebaseFirestore.instance.collection('players').add({
                  'name': nameController.text,
                  'ageGroup': ageController.text,
                  'passing': 0.0,
                  'controlling': 0.0,
                  'dribbling': 0.0,
                  'heading': 0.0,
                  'shooting': 0.0,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - SSB Alam Raya Azzila'),
        backgroundColor: Colors.green[800],
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
        // Stream memperbarui daftar secara otomatis saat data berubah.
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    data['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Kelompok Usia: ${data['ageGroup']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => docs[index].reference.delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        onPressed: () => _showAddPlayerDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
