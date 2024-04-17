// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyB33hBnma4RNhhE6p2MsYa2HjXqwLHcVbY',
    appId: '1:326415440802:web:fbbdff8c746763cfcbb0fb',
    messagingSenderId: '326415440802',
    projectId: 'onlinestore-f09ce',
    authDomain: 'onlinestore-f09ce.firebaseapp.com',
    storageBucket: 'onlinestore-f09ce.appspot.com',
    measurementId: 'G-SE1BECZSL1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCk4AvPj_qw3XxHvWGdVvc0ZMIzZKf5iAk',
    appId: '1:326415440802:android:4466b49dfdb0d689cbb0fb',
    messagingSenderId: '326415440802',
    projectId: 'onlinestore-f09ce',
    storageBucket: 'onlinestore-f09ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnjrD_aF37PoV6maRuPVqF1lvEACGWmlY',
    appId: '1:326415440802:ios:585828ccaaa1aa2ecbb0fb',
    messagingSenderId: '326415440802',
    projectId: 'onlinestore-f09ce',
    storageBucket: 'onlinestore-f09ce.appspot.com',
    iosBundleId: 'com.leandroadal.onlineStore',
  );

}