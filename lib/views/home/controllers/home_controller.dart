import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/event_service.dart';

class HomeController extends GetxController {
  final EventService _eventService = EventService();
  RxList<EventModel> events = <EventModel>[].obs;
  RxBool isLoading = false.obs;

  final searchCtrl = TextEditingController();

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final result = await _eventService.getEvents();
      if (result.left != null) {
        events.assignAll(result.left!);
      } else {
        ToastService.error(
          title: 'Error',
          message: result.right.message ?? 'Failed to fetch events',
        );
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugLog(e.toString());
      ToastService.error(title: 'Error', message: 'Failed to fetch events');
    }
  }

  void deleteEvent(int eventId) async {
    final result = await _eventService.deleteEvent(eventId);
    if (result.success) {
      events.removeWhere((event) => event.id == eventId);
      ToastService.success(
        title: 'Success',
        message: 'Event deleted successfully',
      );
    } else {
      ToastService.error(
        title: 'Error',
        message: result.message ?? 'Failed to delete event',
      );
    }
  }

  void cleanData() {
    searchCtrl.clear();
  }
}
