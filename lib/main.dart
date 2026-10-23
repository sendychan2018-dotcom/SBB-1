import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';

// Menyiapkan Flutter dan Firebase sebelum tampilan aplikasi dibuat.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase dengan konfigurasi Web dari Firebase Console.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Widget root agar aplikasi dapat dipasang langsung pada widget test.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SSBAssessmentApp();
  }
}

class SSBAssessmentApp extends StatelessWidget {
  const SSBAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema dan halaman login menjadi tampilan awal aplikasi.
    return MaterialApp(
      title: 'SSB Alam Raya Azzila',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
