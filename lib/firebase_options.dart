import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'ProfTogo Firebase options are configured for Web and Android only.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDlYRvyjlHLy7_0oUb_A8HJ48dsgFLs_5g',
    appId: '1:173026862363:web:7909664de6e7f4d6d29fbe',
    messagingSenderId: '173026862363',
    projectId: 'elawseducation',
    authDomain: 'elawseducation.firebaseapp.com',
    storageBucket: 'elawseducation.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBafw6mozY9vC15v4kazCxKKPZ-wk_S0_8',
    appId: '1:173026862363:android:ed8da1a759eb9acad29fbe',
    messagingSenderId: '173026862363',
    projectId: 'elawseducation',
    storageBucket: 'elawseducation.firebasestorage.app',
  );
}
