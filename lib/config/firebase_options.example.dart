import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const FirebaseOptions webOptions = FirebaseOptions(
    apiKey: "REPLACE_WITH_YOUR_API_KEY",
    authDomain: "REPLACE_WITH_YOUR_AUTH_DOMAIN",
    projectId: "REPLACE_WITH_YOUR_PROJECT_ID",
    storageBucket: "REPLACE_WITH_YOUR_STORAGE_BUCKET",
    messagingSenderId: "REPLACE_WITH_YOUR_SENDER_ID",
    appId: "REPLACE_WITH_YOUR_APP_ID",
  );
}
