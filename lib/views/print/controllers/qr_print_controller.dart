import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/print/services/print_service_reservation.dart';

class QrPrintController extends GetxController {
  EventModel? selectedData;

  RxList<EventTable> eventTables = <EventTable>[].obs;
  RxBool isLoading = false.obs;

  Rx<EventTable?> selectedTable = Rx<EventTable?>(null);

  void setData(dynamic args) {
    if (args != null && args['data'] is EventModel) {
      selectedData = args['data'];
      eventTables.assignAll(selectedData?.eventTables ?? []);
    }
  }

  void setSelectedTable(EventTable? table) {
    selectedTable.value = table;
  }

  Future<void> printTableQrCodes() async {
    isLoading.value = true;
    try {
      final table = selectedTable.value;
      if (table == null || selectedData == null) return;
      final reservations = selectedData!.reservations
          .where((r) => r.tableId == table.id)
          .toList();
      QRPrintServiceReservation.openPrintWindowForTable(table, reservations);
    } catch (e) {
      // Manejo de errores
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> printSingleQrCode(Reservation reservation) async {
    isLoading.value = true;
    try {
      final table = selectedTable.value;
      if (table == null || selectedData == null) return;
      QRPrintServiceReservation.openPrintWindowForTable(
        table,
        [reservation],
      );
    } catch (e) {
      // Manejo de errores
    } finally {
      isLoading.value = false;
    }
  }
}
