import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';

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
}
