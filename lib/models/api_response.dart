import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse {
  final int statusCode;
  final bool success;
  final String? message;

  ApiResponse({required this.statusCode, required this.success, this.message});
  factory ApiResponse.fromResponse(http.Response response) {
    final decodeJson = json.decode(response.body);
    return ApiResponse(
      statusCode: response.statusCode,
      success: decodeJson['success'] ?? false,
      message: decodeJson['message'] ?? '',
    );
  }
}
