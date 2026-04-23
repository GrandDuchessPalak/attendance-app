import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyACM73p1jKVezPFgPU0MYh6rqrnbIMGKaQ",
      appId: "1:95226770165:web:bb3953a5cd015814498bbc",
      messagingSenderId: "95226770165",
      projectId: "my-devops-clone",
      authDomain: "my-devops-clone.firebaseapp.com",
      storageBucket: "my-devops-clone.firebasestorage.app",
    );
  }
}