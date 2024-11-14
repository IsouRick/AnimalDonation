
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPfAQSU_W-QnqfYtyTHPjTzhKmYLvmU5A',
    appId: '1:680756440227:web:d529924bdcb7266738a316',
    messagingSenderId: '680756440227',
    projectId: 'sweet-1a3e7',
    authDomain: 'sweet-1a3e7.firebaseapp.com',
    storageBucket: 'sweet-1a3e7.firebasestorage.app',
    databaseURL: 'https://sweet-1a3e7-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8xzwpfjHNxRNIIZ6JPXGqfMrfTBwhP00',
    appId: '1:680756440227:android:ccc22714dfe385cc38a316',
    messagingSenderId: '680756440227',
    projectId: 'sweet-1a3e7',
    storageBucket: 'sweet-1a3e7.firebasestorage.app',
    databaseURL: 'https://sweet-1a3e7-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRDawUx9mHDwX3eBews_tNRAD3rZbg1yM',
    appId: '1:680756440227:ios:ab770bd98945f0ff38a316',
    messagingSenderId: '680756440227',
    projectId: 'sweet-1a3e7',
    storageBucket: 'sweet-1a3e7.firebasestorage.app',
    iosBundleId: 'com.example.doacaoAnimal',
    databaseURL: 'https://sweet-1a3e7-default-rtdb.firebaseio.com', 
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPfAQSU_W-QnqfYtyTHPjTzhKmYLvmU5A',
    appId: '1:680756440227:web:fffbacfc9352154238a316',
    messagingSenderId: '680756440227',
    projectId: 'sweet-1a3e7',
    authDomain: 'sweet-1a3e7.firebaseapp.com',
    storageBucket: 'sweet-1a3e7.firebasestorage.app',
    databaseURL: 'https://sweet-1a3e7-default-rtdb.firebaseio.com', 
  );
}
