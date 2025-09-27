import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_check_in/models/either.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';

class GuestUploadController extends GetxController {
  final EventService _eventService = EventService();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController hostName = TextEditingController();
  final TextEditingController totalTables = TextEditingController();
  final TextEditingController totalGuests = TextEditingController();
  final TextEditingController totalCapacity = TextEditingController();
  final TextEditingController availableSpaces = TextEditingController();

  final LoaderController _loaderController = Get.find<LoaderController>();
  EventModel? selectedEvent;

  List<EventReservation> reservations = [];
  List<EventReservation> reservationsFiltered = [];

  final RxList<Guest> guestList = <Guest>[].obs;
  final Rx<XFile?> selectedFile = Rx<XFile?>(null);
  final RxString fileName = ''.obs;

  void setEventData(dynamic args) {
    if (args != null && args['data'] != null && args['data'] is EventModel) {
      selectedEvent = args['data'] as EventModel;
      eventName.text = selectedEvent!.name;
      hostName.text = selectedEvent!.host.fullName;
      totalTables.text =
          selectedEvent?.statistics?.summary.totalTables.toString() ?? '';
      totalGuests.text =
          selectedEvent?.statistics?.summary.totalGuests.toString() ?? '';
      totalCapacity.text =
          selectedEvent?.statistics?.summary.totalCapacity.toString() ?? '';
      availableSpaces.text =
          selectedEvent?.statistics?.summary.availableSpaces.toString() ?? '';
      debugLog('Event selected for bulk upload: ${selectedEvent!.name}');
    }
  }

  void dropGuestFromLists(Guest guest) {
    for (var reservation in reservations) {
      reservation.details.removeWhere((detail) => detail.id == guest.id);
    }
    for (var reservation in reservationsFiltered) {
      reservation.details.removeWhere((detail) => detail.id == guest.id);
    }
    update();
  }

  void filterGuest(String query) {
    if (query.isEmpty) {
      reservationsFiltered = List.from(reservations);
    } else {
      final lowerQuery = query.toLowerCase();
      reservationsFiltered = reservations.where((reservation) {
        final familyMatch = reservation.family.name.toLowerCase().contains(
          lowerQuery,
        );
        final guestMatch = reservation.details.any(
          (guest) =>
              guest.fullName.toLowerCase().contains(lowerQuery) ||
              guest.email.toLowerCase().contains(lowerQuery) ||
              guest.phone.toLowerCase().contains(lowerQuery),
        );
        return familyMatch || guestMatch;
      }).toList();
    }
    update();
  }

  Future<String?> handleUpload() async {
    try {
      _loaderController.show();

      // Use FilePicker to select Excel files specifically
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
        dialogTitle: 'Select Excel file',
      );

      if (result == null || result.files.isEmpty) {
        _loaderController.hide();
        return 'No file was selected';
      }

      PlatformFile platformFile = result.files.first;

      // Create an XFile from the result to maintain compatibility
      XFile pickedFile = XFile(
        platformFile.path ?? '',
        name: platformFile.name,
        bytes: platformFile.bytes,
      );

      // We can omit the additional extension check since FilePicker
      // already filtered the allowed files (.xlsx, .xls) during selection
      selectedFile.value = pickedFile;
      fileName.value = platformFile.name;

      // Get the current event ID (in a real case)
      // final eventId = _sessionController.getCurrentEventId(); // Assuming this method exists

      // For testing, we use a fixed ID
      const int eventId = 1;

      // Read the file as bytes
      Uint8List fileBytes;
      if (kIsWeb) {
        // On web, the bytes already come in the result
        fileBytes = platformFile.bytes!;
      } else {
        // On native platforms, read as file
        if (platformFile.path != null) {
          final File file = File(platformFile.path!);
          fileBytes = await file.readAsBytes();
        } else {
          _loaderController.hide();
          return 'Error accessing the file';
        }
      }

      // Send the file to the server
      final Either<List<EventReservation>?, ApiResponse> response =
          await _eventService.uploadGuestFile(
            eventId: eventId,
            file: fileBytes,
            fileName: pickedFile.name,
          );

      if (!response.right.success) {
        _loaderController.hide();
        return 'Error uploading the file: ${response.right.message}';
      }
      // If the upload was successful, we can process the response
      reservations.assignAll(response.left ?? []);
      reservationsFiltered.assignAll(List.from(reservations));

      _loaderController.hide();
      update();
      return null;
    } catch (e) {
      _loaderController.hide();
      debugLog('Error uploading file: $e');
      return 'Error uploading the file: ${e.toString()}';
    }
  }

  Future<String?> handleSave() async {
    try {
      _loaderController.show();

      if (selectedFile.value == null && reservations.isEmpty) {
        _loaderController.hide();
        return 'Debes seleccionar un archivo primero';
      }

      // Process reservations in batches of 10
      const int batchSize = 10;
      bool allSuccess = true;
      for (int i = 0; i < reservations.length; i += batchSize) {
        final batch = reservations.skip(i).take(batchSize).toList();
        final results = await Future.wait([
          for (EventReservation reservation in batch)
            _eventService.addReservations(reservation),
        ]);
        final batchSuccess = results.every((res) => res.success);
        if (!batchSuccess) {
          allSuccess = false;
          break;
        }
      }
      if (!allSuccess) {
        return 'Error saving some reservations';
      }

      // Clean up after saving
      selectedFile.value = null;
      fileName.value = '';

      _loaderController.hide();
      return null;
    } catch (e) {
      _loaderController.hide();
      debugLog('Error saving: $e');
      return 'Error saving the data: ${e.toString()}';
    }
  }
}
