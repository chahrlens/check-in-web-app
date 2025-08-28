import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';

class HomeController extends GetxController {
  final EventService _eventService = EventService();
  final LoaderController _loaderController = Get.find<LoaderController>();
  RxList<EventModel> events = <EventModel>[].obs;

  final searchCtrl = TextEditingController();

  Future<void> fetchEvents() async {
    try {
      _loaderController.show();
      final result = await _eventService.getEvents();
      if (result.left != null) {
        events.assignAll(result.left!);
      } else {
        Get.snackbar('Error', result.right.message ?? 'Failed to fetch events');
      }
      _loaderController.hide();
    } catch (e) {
      _loaderController.hide();
      debugLog(e.toString());
      Get.snackbar('Error', 'Failed to fetch events');
    }
  }

  void cleanData() {
    searchCtrl.clear();
  }
}
