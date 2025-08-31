import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_check_in/shared/constants/global_keys.dart';
import 'package:qr_check_in/shared/resources/local_storaje.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalStorage _storage = Get.find<LocalStorage>();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the Firebase ID token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await _storage.setString(GlobalKeys.tokenKey, idToken);
        await _storage.setString(GlobalKeys.userIdKey, userCredential.user!.uid);
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _storage.removeElement(GlobalKeys.tokenKey);
      await _storage.removeElement(GlobalKeys.userIdKey);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  bool get isAuthenticated => user.value != null;
  String? get currentUserId => user.value?.uid;
  String? get currentUserEmail => user.value?.email;
}
