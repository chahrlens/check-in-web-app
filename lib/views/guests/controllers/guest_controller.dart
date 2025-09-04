import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/services/toast_service.dart';

class ManageGuestController extends GetxController {
  final EventService _eventService = EventService();
  final LoaderController _loaderController = LoaderController();
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

  //Table controllers
  final eventTableCtrl = TextEditingController();
  final familyNameCtrl = TextEditingController();
  final tableSpaces = TextEditingController();
  final tableUsedSpaces = TextEditingController();
  final tableAvailableSpace = TextEditingController();

  RxBool isLoading = false.obs;
  bool isInputEnabled = true;
  bool autoValidateMode = false;
  RxList<Family> families = <Family>[].obs;
  RxList<EventTable> eventTables = <EventTable>[].obs;
  RxList<EventTable> selectedTables = <EventTable>[].obs;
  RxList<EventTable> currentAssociatedTables = <EventTable>[].obs;

  Rx<EventTable?> selectedTable = Rx<EventTable?>(null);
  List<Reservation> oldReservations = [];
  RxList<ReservationDetails> reservations = <ReservationDetails>[].obs;

  EventModel? selectedEvent;
  Rx<Family?> selectedFamily = Rx<Family?>(null);

  String? validateSpacesToReserve(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    final spaces = int.tryParse(value);
    if (spaces == null) {
      return 'Debe ser un número';
    }
    if (spaces <= 0) {
      return 'Debe ser mayor a 0';
    }

    final table = selectedTable.value;
    if (table != null) {
      // Calcular espacios usados
      int usedSpacesOld = oldReservations
          .where(
            (r) => r.family.familyTables.map((e) => e.id).contains(table.id),
          )
          .fold(0, (sum, r) => sum + r.numCompanions);
      int usedSpacesNew = reservations
          .where((r) => r.tableId == table.id)
          .fold(0, (sum, r) => sum + r.totalOccupants);
      int availableSpaces = table.capacity - (usedSpacesOld + usedSpacesNew);

      if (spaces > availableSpaces) {
        return 'No hay suficientes espacios disponibles';
      }
    }
    return null;
  }

  String? validateGuestName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateGuestLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es requerido';
    }
    if (value.length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }

    // Regex para números de Guatemala (8 dígitos) con o sin código de área
    final guatemalaRegex = RegExp(
      r'^\+?502?\s*-?\s*([0-9]{4})\s*-?\s*([0-9]{4})$|^([0-9]{4})\s*-?\s*([0-9]{4})$',
    );

    // Regex para números de USA
    final usaRegex = RegExp(
      r'^\+?1?\s*-?\s*([0-9]{3})\s*-?\s*([0-9]{3})\s*-?\s*([0-9]{4})$',
    );

    if (!guatemalaRegex.hasMatch(value) && !usaRegex.hasMatch(value)) {
      return 'Formato inválido. Use: XXXX-XXXX o +502-XXXX-XXXX o +1-XXX-XXX-XXXX';
    }
    return null;
  }

  String? validateDPI(String? value) {
    if (value == null || value.isEmpty) {
      return null; // DPI es opcional
    }

    final dpiRegex = RegExp(r'^\d{13}$');
    if (!dpiRegex.hasMatch(value)) {
      return 'DPI debe tener exactamente 13 dígitos';
    }
    return null;
  }

  String? validateNIT(String? value) {
    if (value == null || value.isEmpty) {
      return null; // NIT es opcional
    }

    // Regex para NIT: 5-12 dígitos, puede tener una K/k al final
    // Permite un guion antes del último dígito o K
    final nitRegex = RegExp(r'^\d{4,11}(-?\d|-?[Kk])$');

    if (!nitRegex.hasMatch(value)) {
      return 'Formato inválido. Ej: XXXXXX-X o XXXXXX-K';
    }
    return null;
  }

  Future<bool> handleSave() async {
    try {
      if (selectedEvent == null || reservations.isEmpty) {
        ToastService.error(
          title: "Error",
          message: "No event selected or no reservations made",
        );
        return false;
      }
      final EventReservation reservation = EventReservation(
        eventId: selectedEvent!.id,
        details: reservations,
      );
      final response = await _eventService.addReservations(reservation);
      if (response.success) {
        ToastService.success(
          title: "Success",
          message: "Reservations added successfully",
        );
        return true;
      } else {
        ToastService.error(
          title: "Error",
          message: response.message ?? "Unknown error",
        );
      }
      return false;
    } catch (e) {
      ToastService.error(title: "Error", message: e.toString());
      return false;
    }
  }

  void setEventData(dynamic args) {
    if (args != null && args['data'] is EventModel) {
      selectedEvent = args['data'];
      hostName.text = selectedEvent?.host.fullName ?? '';
      eventName.text = selectedEvent?.name ?? '';
      totalSpaces.text = selectedEvent?.totalSpaces.toString() ?? '';
      totalTables.text = selectedEvent?.tableCount.toString() ?? '';
      oldReservations.assignAll(selectedEvent?.reservations ?? []);

      int usedSpaces = oldReservations.fold(
        0,
        (sum, r) => sum + r.numCompanions,
      );
      int availableSpaces_ = (selectedEvent?.totalSpaces ?? 0) - usedSpaces;

      reservedSpaces.text = usedSpaces.toString();
      availableSpaces.text = availableSpaces_.toString();
    }
  }

  void setSelectedTable() {
    final int availableAssociatedSpaces = currentAssociatedTables.fold(
      0,
      (sum, table) => sum + table.availableCapacity,
    );
    final int availableSpace = selectedTables.fold(
      0,
      (sum, table) => sum + table.availableCapacity,
    );

    final int totalAvailableSpaces = availableAssociatedSpaces + availableSpace;

    final int totalCapacity =
        selectedTables.fold(0, (sum, table) => sum + table.capacity) +
        currentAssociatedTables.fold(0, (sum, table) => sum + table.capacity);

    // Calcular espacios usados de reservaciones viejas
    int totalUsedSpaces = 0;
    for (var table in selectedTables) {
      totalUsedSpaces += oldReservations
          .where(
            (r) => r.family.familyTables.map((e) => e.id).contains(table.id),
          )
          .fold(0, (sum, r) => sum + r.numCompanions + 1);
    }
    for (var table in currentAssociatedTables) {
      totalUsedSpaces += oldReservations
          .where(
            (r) => r.family.familyTables.map((e) => e.id).contains(table.id),
          )
          .fold(0, (sum, r) => sum + r.numCompanions + 1);
    }

    // Calcular espacios usados de reservaciones nuevas
    int usedSpacesNew = reservations.length;
    tableSpaces.text = totalCapacity.toString();

    tableUsedSpaces.text = (totalUsedSpaces + usedSpacesNew).toString();
    tableAvailableSpace.text = totalAvailableSpaces.toString();

    // Validar si hay espacios disponibles
    if (usedSpacesNew >= totalAvailableSpaces) {
      isInputEnabled = false;
    } else {
      isInputEnabled = true;
    }
    update();
  }

  void setTableDataWithFamily(Family? family) {
    currentAssociatedTables.clear();
    selectedTables.clear();
    if (family != null) {
      selectedFamily.value = family;
      final Reservation? reservation = selectedEvent?.reservations
          .firstWhereOrNull((r) => r.family.id == family.id);

      final List<int> reservationTableIds =
          reservation?.family.familyTables.map((e) => e.tableId).toList() ?? [];
      currentAssociatedTables.assignAll(
        eventTables.where((t) => reservationTableIds.contains(t.id)).toList(),
      );
    } else {
      selectedFamily.value = null;
    }
    setSelectedTable();
    update();
  }

  List<int> getAssociatedTableIds() {
    return currentAssociatedTables.map((t) => t.id).toList();
  }

  void cleanGuest() {
    guestName.clear();
    guestLastName.clear();
    phone.clear();
    dpi.clear();
    nit.clear();
    tableId.clear();
    numCompanions.clear();
    eventTableCtrl.clear();
    selectedTable.value = null;
    tableSpaces.clear();
    tableUsedSpaces.clear();
  }

  void appendReservation() {
    if (selectedTable.value == null) {
      ToastService.error(title: "Error", message: "Please select a table");
      return;
    }
    final ReservationDetails newReservation = ReservationDetails(
      guestName: guestName.text,
      guestLastName: guestLastName.text,
      phone: phone.text,
      dpi: dpi.text,
      nit: nit.text,
      tableId: selectedTable.value!.id,
      table: selectedTable.value!.name,
      totalOccupants: int.tryParse(tableAvailableSpace.text) ?? 0,
    );

    reservations.add(newReservation);

    cleanGuest();
  }

  Future<void> getFamilies() async {
    try {
      final response = await _eventService.getFamilies();
      if (response.right.success) {
        families.assignAll(response.left ?? []);
      } else {
        ToastService.warning(
          title: "Warning",
          message: response.right.message ?? "Unknown error",
        );
      }
    } catch (e) {
      ToastService.warning(title: 'Error', message: e.toString());
    }
  }

  Future<void> getEventTables({required int eventId}) async {
    try {
      final response = await _eventService.getEventTables(eventId: eventId);
      if (response.right.success) {
        eventTables.assignAll(response.left ?? []);
        eventTables.sort((a, b) => a.tableNumber.compareTo(b.tableNumber));
      } else {
        ToastService.warning(
          title: "Warning",
          message: response.right.message ?? "Unknown error",
        );
      }
    } catch (e) {
      ToastService.warning(title: 'Error', message: e.toString());
    }
  }

  Future<void> getAll() async {
    _loaderController.show();
    await Future.wait([
      getFamilies(),
      getEventTables(eventId: selectedEvent?.id ?? 0),
    ]);
    _loaderController.hide();
    update();
  }

  @override
  void onReady() {
    super.onReady();
    getAll();
  }
}
