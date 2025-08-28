import 'dart:convert';

import 'package:qr_check_in/models/either.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/services/base_service.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';

class EventService extends BaseService {
  Future<Either<List<EventModel>?, ApiResponse>> getEvents() async {
    try {
      final response = await httpClient.get(buildUri('/event/v1/events'));
      final apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Iterable listData = decodedJson['data'] ?? [];
        final data = listData.map((e) => EventModel.fromJson(e)).toList();
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

  Future<ApiResponse> createEvent({required EventModel data}) async {
    try {
      final body = data.toJson();
      final response = await httpClient.post(
        buildUri('/event/v1/events'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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

  Future<ApiResponse> updateEvent({required EventModel data}) async {
    try {
      final body = data.toPutJson();
      final response = await httpClient.put(
        buildUri('/event/v1/events'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
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

  Future<ApiResponse> addEventTables({
    required int eventId,
    required List<EventTable> data,
  }) async {
    try {
      final jsonData = {
        'eventId': eventId,
        "tablesData": data.map((e) => e.toJson()).toList(),
      };
      final response = await httpClient.post(
        buildUri('/event/v1/events/$eventId/tables'),
        body: json.encode(jsonData),
        headers: {'Content-Type': 'application/json'},
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
