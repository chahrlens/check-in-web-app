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
      eventTables.sort((a, b) => a.id.compareTo(b.id));
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

      // Obtener todos los ReservationMember asignados directamente a esta mesa por tableId
      final reservationMembers = selectedData!.reservations
          .expand((r) => r.reservationMembers)
          .where((member) => member.tableId == table.id)
          .toList();

      QRPrintServiceReservation.openPrintWindowForTable(
        table,
        reservationMembers,
      );
    } catch (e) {
      // Manejo de errores
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> printSingleQrCode(ReservationMember reservation) async {
    isLoading.value = true;
    try {
      final EventTable? table = selectedTable.value;
      if (table == null || selectedData == null) return;
      QRPrintServiceReservation.openPrintWindowForTable(table, [reservation]);
    } catch (e) {
      // Manejo de errores
    } finally {
      isLoading.value = false;
    }
  }
}
