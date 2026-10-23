import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SSBAssessmentApp());
}

class SSBAssessmentApp extends StatelessWidget {
  const SSBAssessmentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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