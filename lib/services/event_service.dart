import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_check_in/models/either.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/services/base_service.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';

class EventService extends BaseService {
  final SessionController _sessionController = Get.find<SessionController>();
  Map<String, String> get _authHeaders {
    final token = _sessionController.token.value;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Either<List<EventModel>?, ApiResponse>> getEvents() async {
    try {
      final response = await httpClient.get(
        buildUri('/event/v1/events'),
        headers: _authHeaders,
      );
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
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      debugLog('Create Event Response: ${apiResponse.message}');
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
        buildUri('/event/v1/events/tables'),
        body: json.encode(jsonData),
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

  Future<ApiResponse> addReservations(EventReservation reservations) async {
    try {
      final data = reservations.toJson();
      debugLog('Reservation Data: $data');
      final response = await httpClient.post(
        buildUri('/event/v1/events/reservations'),
        body: json.encode(data),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  ///event/reservations-members-bulk
  Future<ApiResponse> addReservationsBulk(List<EventReservation> reservations) async {
    try {
      final data = reservations.map((e) => e.toJson()).toList();
      debugLog('Bulk Reservation Data: $data');
      final response = await httpClient.post(
        buildUri('/event/v1/events/reservations-members-bulk'),
        body: json.encode(data),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<ApiResponse> deleteEvent(int eventId) async {
    try {
      final response = await httpClient.delete(
        buildUri('/event/v1/events/', queryParameters: {"eventId": eventId}),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<ApiResponse> deleteReservations(List<int> reservationIds) async {
    try {
      final response = await httpClient.delete(
        buildUri('/event/v1/events/reservations'),
        body: json.encode({"reservationIds": reservationIds}),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<Either<List<Family>?, ApiResponse>> getFamilies() async {
    try {
      final response = await httpClient.get(
        buildUri('/event/v1/events/families'),
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Iterable listData = decodedJson['data'] ?? [];
        final data = listData.map((e) => Family.fromJson(e)).toList();
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

  Future<ApiResponse> deleteFamily(int familyId) async {
    try {
      final response = await httpClient.delete(
        buildUri(
          '/event/v1/events/families',
          queryParameters: {"familyId": familyId},
        ),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<Either<List<EventTable>?, ApiResponse>> getEventTables({
    required int eventId,
    int filterAvailable = 1,
  }) async {
    try {
      final response = await httpClient.get(
        buildUri(
          '/event/v1/events/tables',
          queryParameters: {
            "eventId": eventId,
            "filterAvailable": filterAvailable,
          },
        ),
        headers: _authHeaders,
      );
      final apiResponse = ApiResponse.fromResponse(response);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Iterable listData = decodedJson['data'] ?? [];
        final data = listData.map((e) => EventTable.fromJson(e)).toList();
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

  Future<ApiResponse> appendGuestsToBooking({
    required int reservationId,
    required List<Guest> guests,
    List<int>? additionalTables,
  }) async {
    try {
      final body = {
        "reservationId": reservationId,
        "guests": guests.map((e) => e.toJson()).toList(),
        "additionalTables": additionalTables,
      };
      final response = await httpClient.put(
        buildUri('/event/v1/events/reservations-members'),
        body: json.encode(body),
        headers: _authHeaders,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      debugLog(e.toString());
      return ApiResponse(
        statusCode: 500,
        success: false,
        message: 'An error occurred',
      );
    }
  }

  Future<Either<List<EventReservation>?, ApiResponse>> uploadGuestFile({
    required int eventId,
    required Uint8List file,
    required String fileName,
  }) async {
    try {
      var uri = buildUri('/event/v1/events/guest-upload/$eventId');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll(_authHeaders);

      request.fields['eventId'] = eventId.toString();

      request.files.add(
        http.MultipartFile.fromBytes('file', file, filename: fileName),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        Iterable listData = decodedJson['data']['familyReservations'] ?? [];
        final data = listData.map((e) => EventReservation.fromJson(e)).toList();
        return Either(left: data, right: ApiResponse.fromResponse(response));
      }
      return Either(left: null, right: ApiResponse.fromResponse(response));
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
}
