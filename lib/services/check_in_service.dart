import 'dart:convert';
import 'package:get/get.dart';
import 'package:qr_check_in/models/either.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/models/check_in_model.dart';
import 'package:qr_check_in/services/base_service.dart';

class CheckInService extends BaseService {
  final SessionController _sessionController = Get.find<SessionController>();

  Map<String, String> get _authHeaders {
    final token = _sessionController.token.value;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Either<CheckInModel?, ApiResponse>> getCheckInDetails(
    String uuid,
  ) async {
    try {
      final response = await httpClient.get(
        buildUri('/check-in/v1/availability/$uuid'),
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        final data = CheckInModel.fromJson(decodedJson['data']);
        return Either(left: data, right: apiResponse);
      }
      return Either(left: null, right: apiResponse);
    } catch (e) {
      debugLog(e.toString());
      return Either(
        left: null,
        right: ApiResponse(
          statusCode: 500,
          success: false,
          message: 'An error occurred',
        ),
      );
    }
  }

  Future<ApiResponse> performCheckIn({
    required int numCompanionsEntered,
    required String uuidCode,
    required bool guestEntered,
  }) async {
    try {
      final body = {
        'numCompanionsEntered': numCompanionsEntered,
        'uuidCode': uuidCode,
        'guestEntered': guestEntered,
      };
      final response = await httpClient.post(
        buildUri('/check-in/v1/check-in'),
        body: json.encode(body),
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      return apiResponse;
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<Either<Guest?, ApiResponse>> getGuestByUuid(String uuid) async {
    try {
      final response = await httpClient.get(
        buildUri('/check-in/v1/person/$uuid'),
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        final data = Guest.fromJson(decodedJson['data']);
        return Either(left: data, right: apiResponse);
      }
      return Either(left: null, right: apiResponse);
    } catch (e) {
      debugLog(e.toString());
      return Either(
        left: null,
        right: ApiResponse(
          statusCode: 500,
          success: false,
          message: 'An error occurred',
        ),
      );
    }
  }

  Future<ApiResponse> updateGuestInfo(Guest guest) async {
    try {
      if (guest.id == 0) {
        return ApiResponse(
          statusCode: 400,
          success: false,
          message: 'Invalid guest ID',
        );
      }
      final jsonData = json.encode(guest.toJson());
      final response = await httpClient.put(
        buildUri('/check-in/v1/person/${guest.id}'),
        body: jsonData,
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      return apiResponse;
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }
}
