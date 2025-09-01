import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/event_service.dart';

class RemovePassesController extends GetxController {
  final EventService _eventService = EventService();
  EventModel? selectedData;

  RxList<EventTable> eventTables = <EventTable>[].obs;
  RxBool isLoading = false.obs;

  Rx<EventTable?> selectedTable = Rx<EventTable?>(null);

  void setSelectedEvent(dynamic args) {
    if (args != null && args['data'] is EventModel) {
      selectedData = args['data'];
      eventTables.assignAll(selectedData?.eventTables ?? []);
    }
  }

  void setSelectedTable(EventTable? table) {
    selectedTable.value = table;
  }

  Future<bool> deleteTable() async {
    try {
      final table = selectedTable.value;
      if (table != null) {
        isLoading.value = true;
        final int selectedTableId = table.id;
        List<int> deletedIds = selectedData!.reservations
            .where((reservation) => reservation.tableId == selectedTableId)
            .map((reservation) => reservation.id)
            .toList();
        final response = await _eventService.deleteReservations(deletedIds);
        if (response.success) {
          eventTables.remove(table);
          selectedTable.value = null;
          Get.snackbar('Success', 'Table deleted successfully');
          return true;
        } else {
          Get.snackbar('Error', response.message ?? 'Unknown error');
        }
        isLoading.value = false;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete table');
      debugLog(e.toString());
      return false;
    }
  }

  Future<bool> deleteElement(Reservation reservation) async {
    try {
      final table = selectedTable.value;
      if (table != null && selectedData != null) {
        isLoading.value = true;
        final result = await _eventService.deleteReservations([reservation.id]);
        if (result.success) {
          selectedData!.reservations.remove(reservation);
          Get.snackbar('Success', 'Reservation deleted successfully');
          return true;
        } else {
          Get.snackbar('Error', result.message ?? 'Unknown error');
        }
        isLoading.value = false;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reservation');
      debugLog(e.toString());
      return false;
    }
  }
}
