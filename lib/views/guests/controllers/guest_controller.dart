import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';

class ManageGuestController extends GetxController {
  //host data
  final hostName = TextEditingController();
  final eventName = TextEditingController();
  final totalSpaces = TextEditingController();
  final totalTables = TextEditingController();
  final reservedSpaces = TextEditingController();
  final availableSpaces = TextEditingController();

  
  final guestName = TextEditingController();
  final guestLastName = TextEditingController();
  final phone = TextEditingController();
  final dpi = TextEditingController();
  final nit = TextEditingController();
  final tableId = TextEditingController();
  final numCompanions = TextEditingController();



  RxList<EventTable> eventTables = <EventTable>[].obs;
  Rx<EventTable?> selectedTable = Rx<EventTable?>(null);
  RxList<Reservation> reservations = <Reservation>[].obs;

  EventModel? selectedEvent;

  void setEventData(dynamic args) {
    if (args != null && args['data'] is EventModel) {
      selectedEvent = args['data'];
      hostName.text = selectedEvent?.host.fullName ?? '';
      eventName.text = selectedEvent?.name ?? '';
      totalSpaces.text = selectedEvent?.totalSpaces.toString() ?? '';
      totalTables.text = selectedEvent?.tableCount.toString() ?? '';
      eventTables.assignAll(selectedEvent?.eventTables ?? []);
      reservations.assignAll(selectedEvent?.reservations ?? []);

      int usedSpaces = reservations.fold(0, (sum, r) => sum + r.numCompanions);
      int availableSpaces_ = (selectedEvent?.totalSpaces ?? 0) - usedSpaces;

      reservedSpaces.text = usedSpaces.toString();
      availableSpaces.text = availableSpaces_.toString();
    }
  }
}
