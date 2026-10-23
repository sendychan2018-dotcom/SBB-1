import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Menyediakan konfigurasi Firebase untuk platform yang sudah didaftarkan.
class DefaultFirebaseOptions {
  // Konfigurasi aplikasi Web dari Firebase Console proyek SBB-1.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAL-liRwmMCMDG74RKNMilwh0s-ylDFKbk',
    appId: '1:139298764192:web:3725fbb5b7553c646920c5',
    messagingSenderId: '139298764192',
    projectId: 'sbb-1-461a3',
    authDomain: 'sbb-1-461a3.firebaseapp.com',
    storageBucket: 'sbb-1-461a3.firebasestorage.app',
    measurementId: 'G-DQXJC9PE2H',
  );

  /// Mengubah nilai konfigurasi menjadi objek yang dipakai Firebase SDK.
  static FirebaseOptions get currentPlatform {
    // Firebase Console yang diberikan mendaftarkan aplikasi Web saja.
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'Firebase options are only configured for Flutter Web.',
    );
  }
}
