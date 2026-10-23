import 'package:cloud_firestore/cloud_firestore.dart';

// Representasi data pemain yang disimpan pada koleksi Firestore.
class PlayerModel {
  final String id;
  final String name;
  final String ageGroup;
  final double passing;
  final double controlling;
  final double dribbling;
  final double heading;
  final double shooting;

  PlayerModel({
    required this.id,
    required this.name,
    required this.ageGroup,
    required this.passing,
    required this.controlling,
    required this.dribbling,
    required this.heading,
    required this.shooting,
  });

  // Mengubah model menjadi map dengan nama field yang dipakai Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ageGroup': ageGroup,
      'passing': passing,
      'controlling': controlling,
      'dribbling': dribbling,
      'heading': heading,
      'shooting': shooting,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Membuat model dari dokumen Firestore dan memberi nilai aman untuk field kosong.
  factory PlayerModel.fromMap(String id, Map<String, dynamic> map) {
    return PlayerModel(
      id: id,
      name: map['name'] ?? '',
      ageGroup: map['ageGroup'] ?? '',
      passing: (map['passing'] ?? 0).toDouble(),
      controlling: (map['controlling'] ?? 0).toDouble(),
      dribbling: (map['dribbling'] ?? 0).toDouble(),
      heading: (map['heading'] ?? 0).toDouble(),
      shooting: (map['shooting'] ?? 0).toDouble(),
    );
  }
}
