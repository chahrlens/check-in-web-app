import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/shared/constants/config.dart';

abstract class BaseService {
  String get baseUrl => Config.endPointBaseUrl;

  http.Client get httpClient => http.Client();

  Map<String, String> buildHeaders() {
    final authController = Get.find<SessionController>();
    final String bearer = 'bearer ${authController.getToken}';
    return {'Authorization': bearer, 'Content-Type': 'application/json'};
  }

  String buildQueryParameters(Map<String, dynamic> params) {
    if (params.isEmpty) return '';
    final queryString = params.entries
        .where(
          (entry) => entry.value != null && entry.value.toString().isNotEmpty,
        )
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}',
        )
        .join('&');
    return queryString.isNotEmpty ? '?$queryString' : '';
  }

  Uri buildUri(String path, {Map<String, dynamic>? queryParameters}) {
    final params = buildQueryParameters(queryParameters ?? {});
    final uri = Uri.parse('$baseUrl$path$params');
    return uri;
  }
}
