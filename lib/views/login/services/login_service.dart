import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_check_in/models/session_model.dart';
import 'package:qr_check_in/shared/constants/config.dart';
import 'package:qr_check_in/shared/helpers/encryption.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';


class LoginService {
  Future<UserData?> loginUser(String username, String password) async {
    final url = Uri.parse(
        '${Config.endPointBaseUrl}/auth/login'); // Reemplaza con tu IP local

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 202) {
        final decodedJson = jsonDecode(response.body);
        final decryptedData = decObfuscateValue(decodedJson['data']);
        final userData = jsonDecode(decryptedData);
        final data = {
          'success': decodedJson['success'],
          'data': userData,
        };
        debugLog(userData.toString());
        final loginResponse = SessionResponse.fromJson(data);
        return loginResponse.data; // Retorna el UserData
      } else {
        return null;
      }
    } catch (e) {
      debugLog('Error al conectarse con la API: $e');
      return null;
    }
  }

  Future<UserData?> retrieveUserData(String token, String userId) async {
    final url = Uri.parse('${Config.endPointBaseUrl}/auth/getUser?id=$userId');

    try {
      final String bearer = 'Bearer $token';
      final String encryptedBearer = obfuscateValue(bearer);
      final response = await http.get(
        url,
        headers: {
          'Authorization': encryptedBearer,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final decryptedData = decObfuscateValue(decodedJson['data']);
        final userData = jsonDecode(decryptedData);
        return UserData.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      debugLog('Error al obtener datos del usuario: $e');
      return null;
    }
  }
}
