// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAckHGCxTqypk93JH3LEnbEJCM5m71MinU',
    appId: '1:245390768336:web:5b1c6dfd87ff6a3e4c46d5',
    messagingSenderId: '245390768336',
    projectId: 'snippets2024',
    authDomain: 'snippets2024.firebaseapp.com',
    storageBucket: 'snippets2024.appspot.com',
    measurementId: 'G-YFB8JKNXXV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlaXvNPEnLdQn5Cn7KWwhR1Rc5D6diawY',
    appId: '1:245390768336:android:b4faf7b7b1d3200f4c46d5',
    messagingSenderId: '245390768336',
    projectId: 'snippets2024',
    storageBucket: 'snippets2024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA81JdmJjbsHvFJmAhm1toWApX29-K7nNk',
    appId: '1:245390768336:ios:73ffe79b2d6448024c46d5',
    messagingSenderId: '245390768336',
    projectId: 'snippets2024',
    storageBucket: 'snippets2024.appspot.com',
    iosBundleId: 'com.kazoom.snippet',
  );
}
