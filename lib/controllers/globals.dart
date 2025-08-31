import 'dart:async';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_check_in/shared/constants/global_keys.dart';
import 'package:qr_check_in/shared/helpers/encryption.dart';
import 'package:qr_check_in/shared/resources/local_storaje.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/auth_service.dart';


class SessionController extends GetxController {
  final LocalStorage _storageController = Get.find<LocalStorage>();
  final AuthService _authService = Get.find<AuthService>();

  var username = ''.obs;
  var token = ''.obs;
  var userId = ''.obs; // Changed to String for Firebase UID compatibility


  RxBool isLoading = false.obs;

  bool get isTokenExpired {
    if (token.value.isEmpty) return true;
    return JwtDecoder.isExpired(token.value);
  }

  // Métodos para setear los valores
  void setUsername(String value) {
    username.value = value;
  }

  void setToken(String value) {
    token.value = value;
  }

  void setUserId(String id) {
    userId.value = id;
  }

  // Métodos para acceder si quieres usar sin `.value`
  String get getUsername => username.value;
  String get getToken => token.value;
  String get getUserId => userId.value;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      if (userCredential != null) {
        setUsername(email);
        setUserId(userCredential.user!.uid);
        final idToken = await userCredential.user!.getIdToken();
        setToken(idToken ?? '');
        return true;
      }
      return false;
    } catch (e) {
      debugLog('Error signing in: $e');
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _authService.signOut();
      username.value = '';
      token.value = '';
      userId.value = '';

      // Limpieza de la sesión
      //Clear local storage
      await Future.wait([
        _storageController.removeElement(GlobalKeys.tokenKey),
        _storageController.removeElement(GlobalKeys.userIdKey),
      ]);
    } catch (e) {
      debugLog('Error signing out: $e');
    }
  }

  Map<String, String> generateEncryptedHeaders() {
    final String bearer = 'bearer $getToken';
    final String encryptedBearer = obfuscateValue(bearer);

    return {
      'Authorization': encryptedBearer,
      'Content-Type': 'application/json',
    };
  }

  bool tokenIsValid(String? token) {
    if (token == null || token.isEmpty) {
      return false;
    }
    bool isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  @override
  void onInit() {
    super.onInit();
    _getSessionStorage();
  }

  Future<bool> _getSessionStorage() async {
    try {
      isLoading.value = true;
      final results = await Future.wait([
        _storageController.getString(GlobalKeys.tokenKey),
        _storageController.getString(GlobalKeys.userIdKey),
      ]);
      final sessionToken = results[0];
      final storedUserId = results[1];

      // Si no hay token o userId almacenados, no hay sesión válida
      if (sessionToken == null || storedUserId == null) {
        await logOut();  // Aseguramos limpiar todo
        return false;
      }

      // Verificar si el token es válido
      if (!tokenIsValid(sessionToken)) {
        await logOut();  // Limpiamos la sesión si el token expiró
        return false;
      }

      // Actualizar el estado de la sesión con los valores almacenados
      setToken(sessionToken);
      setUserId(storedUserId);

      // Intentar renovar el token con Firebase
      try {
        final currentUser = _authService.getCurrentUser();
        if (currentUser != null) {
          final newToken = await currentUser.getIdToken(true); // true fuerza la renovación
          if (newToken != null) {
            setToken(newToken);
            await _storageController.setString(GlobalKeys.tokenKey, newToken);
          }
          setUsername(currentUser.email ?? '');
          return true;
        } else {
          await logOut();  // Si no hay usuario en Firebase, limpiamos la sesión
          return false;
        }
      } catch (e) {
        debugLog('Error renovando token: $e');
        await logOut();
        return false;
      }
    } catch (e) {
      debugLog('Error in getSessionStorage: $e');
      await logOut();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
