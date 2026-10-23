import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class CoachDashboard extends StatelessWidget {
  const CoachDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelatih - Penilaian Skill Pemain'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('players').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String docId = docs[index].id;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Passing: ${data['passing']} | Shooting: ${data['shooting']}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InputSkillPage(playerId: docId, playerName: data['name'], currentData: data)),
                    ),
                    child: const Text('Beri Nilai', style: TextStyle(color: Colors.white)),
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

class InputSkillPage extends StatefulWidget {
  final String playerId;
  final String playerName;
  final Map<String, dynamic> currentData;

  const InputSkillPage({Key? key, required this.playerId, required this.playerName, required this.currentData}) : super(key: key);

  @override
  _InputSkillPageState createState() => _InputSkillPageState();
}

class _InputSkillPageState extends State<InputSkillPage> {
  late double _passing;
  late double _controlling;
  late double _dribbling;
  late double _heading;
  late double _shooting;

  @override
  void initState() {
    super.initState();
    _passing = (widget.currentData['passing'] ?? 0.0).toDouble();
    _controlling = (widget.currentData['controlling'] ?? 0.0).toDouble();
    _dribbling = (widget.currentData['dribbling'] ?? 0.0).toDouble();
    _heading = (widget.currentData['heading'] ?? 0.0).toDouble();
    _shooting = (widget.currentData['shooting'] ?? 0.0).toDouble();
  }

  void _save() async {
    await FirebaseFirestore.instance.collection('players').doc(widget.playerId).update({
      'passing': _passing,
      'controlling': _controlling,
      'dribbling': _dribbling,
      'heading': _heading,
      'shooting': _shooting,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  Widget _buildSlider(String label, double val, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${val.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(value: val, min: 0, max: 100, divisions: 100, onChanged: onChanged),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nilai: ${widget.playerName}'), backgroundColor: Colors.green[700]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSlider('Passing', _passing, (v) => setState(() => _passing = v)),
          _buildSlider('Controlling', _controlling, (v) => setState(() => _controlling = v)),
          _buildSlider('Dribbling', _dribbling, (v) => setState(() => _dribbling = v)),
          _buildSlider('Heading', _heading, (v) => setState(() => _heading = v)),
          _buildSlider('Shooting', _shooting, (v) => setState(() => _shooting = v)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.all(14)),
            onPressed: _save,
            child: const Text('Simpan Perubahan Nilai', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}