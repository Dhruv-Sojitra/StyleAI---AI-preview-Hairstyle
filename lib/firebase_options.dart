// File generated manually based on google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXTkcojaOckQFXTHxxHCf6wk-GEBTLD2A',
    appId: '1:151169884094:android:b4676f17e6dce3e7e963ef',
    messagingSenderId: '151169884094',
    projectId: 'aihairstylist-25170',
    storageBucket: 'aihairstylist-25170.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXTkcojaOckQFXTHxxHCf6wk-GEBTLD2A',
    appId: '1:151169884094:android:b4676f17e6dce3e7e963ef', // Reusing ID for dev; replace with Windows-specific app ID if auth issues persist
    messagingSenderId: '151169884094',
    projectId: 'aihairstylist-25170',
    storageBucket: 'aihairstylist-25170.firebasestorage.app',
  );
}
