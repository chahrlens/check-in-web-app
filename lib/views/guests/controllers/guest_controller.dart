import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';

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
  RxList<Guest> guests = <Guest>[].obs;

  Rx<EventTable?> selectedTable = Rx<EventTable?>(null);
  List<Reservation> oldReservations = [];

  EventModel? selectedEvent;
  Reservation? selectedReservation; // For editing existing reservation
  EventReservation? newEventReservation; // For new reservation
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
      int usedSpacesNew = guests.length;
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

  Future<bool> saveReservation() async {
    try {
      if (newEventReservation == null) {
        ToastService.error(title: "Error", message: "No reservation data");
        return false;
      }
      final result = await _eventService.addReservations(newEventReservation!);
      if (result.success) {
        ToastService.success(
          title: "Success",
          message: "Reservation saved successfully",
        );
        return true;
      }

      ToastService.error(
        title: "Error",
        message: result.message ?? "Unknown error",
      );
      return false;
    } catch (e) {
      ToastService.error(title: "Error", message: e.toString());
      return false;
    }
  }

  Future<bool> updateGuestDetails() async {
    try {
      if (selectedReservation == null) {
        ToastService.error(title: "Error", message: "No reservation selected");
        return false;
      }
      final List<int> oldAssociatedTableIds = selectedReservation!
          .family
          .familyTables
          .map((e) => e.tableId)
          .toList();
      List<int> associatedTableIds = getAssociatedTableIds();
      // Remover IDs que ya estaban asociadas para no duplicar
      associatedTableIds.removeWhere(
        (id) => oldAssociatedTableIds.contains(id),
      );
      final result = await _eventService.appendGuestsToBooking(
        reservationId: selectedReservation!.id,
        guests: guests.toList(),
        additionalTables: associatedTableIds.isEmpty
            ? null
            : associatedTableIds,
      );
      if (result.success) {
        ToastService.success(
          title: "Success",
          message: "Guest details updated successfully",
        );
        return true;
      }
      ToastService.error(
        title: "Error",
        message: result.message ?? "Unknown error",
      );
      return false;
    } catch (e) {
      ToastService.error(title: "Error", message: e.toString());
      return false;
    }
  }

  Future<bool> handleSave() async {
    try {
      if (guests.isEmpty || selectedEvent == null) {
        ToastService.error(
          title: "Error",
          message: "No guests added or no event selected",
        );
        return false;
      }
      if (newEventReservation != null) {
        return saveReservation();
      } else if (selectedReservation != null) {
        return updateGuestDetails();
      } else {
        ToastService.error(title: "Error", message: "No reservation data");
        return false;
      }
    } catch (e) {
      ToastService.error(title: "Error", message: e.toString());
      return false;
    }
  }

  bool isAnonymous() {
    return guestName.text.isEmpty &&
        guestLastName.text.isEmpty &&
        phone.text.isEmpty &&
        dpi.text.isEmpty &&
        nit.text.isEmpty;
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

  void updateTableStatics() {
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
    int usedSpacesNew = guests.length;
    tableSpaces.text = totalCapacity.toString();
    tableUsedSpaces.text = (totalUsedSpaces + usedSpacesNew).toString();
    // Reducir dinámicamente el input de espacios disponibles
    final remainingSpaces = totalAvailableSpaces - usedSpacesNew;
    tableAvailableSpace.text = remainingSpaces > 0
        ? remainingSpaces.toString()
        : '0';

    // Validar si hay espacios disponibles
    if (remainingSpaces <= 0) {
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
      newEventReservation = null;
      selectedFamily.value = family;
      final Reservation? reservation = selectedEvent?.reservations
          .firstWhereOrNull((r) => r.family.id == family.id);
      selectedReservation = reservation;

      final List<int> reservationTableIds =
          reservation?.family.familyTables.map((e) => e.tableId).toList() ?? [];
      currentAssociatedTables.assignAll(
        eventTables.where((t) => reservationTableIds.contains(t.id)).toList(),
      );
    } else {
      selectedFamily.value = null;
      selectedReservation = null;
    }
    updateTableStatics();
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
    if (selectedTables.isEmpty || familyNameCtrl.text.isEmpty) {
      ToastService.error(
        title: "Error",
        message: "No family or tables selected",
      );
      return;
    }

    final List<FamilyTable> tables = selectedTables
        .map<FamilyTable>((table) => FamilyTable.fromEventTable(table))
        .toList();
    if (newEventReservation != null) {
      final newGuest = Guest.instance(
        firstName: guestName.text.isEmpty ? 'anonymous' : guestName.text,
        lastName: guestLastName.text,
        phone: phone.text,
        dpi: dpi.text,
        nit: nit.text,
      );
      guests.add(newGuest);
      newEventReservation?.details = guests.toList();
    } else {
      final newFamily = Family.instance(
        name: familyNameCtrl.text,
        familyTables: tables,
      );

      final newGuest = Guest.instance(
        firstName: guestName.text,
        lastName: guestLastName.text,
        phone: phone.text,
        dpi: dpi.text,
        nit: nit.text,
      );

      guests.add(newGuest);

      final newReservation = EventReservation.instance(
        eventId: selectedEvent?.id ?? 0,
        family: newFamily,
        details: guests.toList(),
      );
      newEventReservation = newReservation;
    }

    cleanGuest();
    updateTableStatics();
  }

  void appendData() {
    if (selectedReservation != null) {
      final isAnon = isAnonymous();
      if (isAnon) {
        guests.add(
          Guest.instance(
            firstName: 'anonymous',
            lastName: guestLastName.text,
            phone: phone.text,
            dpi: dpi.text,
            nit: nit.text,
          ),
        );
      } else {
        guests.add(
          Guest.instance(
            firstName: guestName.text,
            lastName: guestLastName.text,
            phone: phone.text,
            dpi: dpi.text,
            nit: nit.text,
          ),
        );
      }
      cleanGuest();
      updateTableStatics();
    } else {
      appendReservation();
    }
  }

  void removeGuestAt(int index) {
    if (index >= 0 && index < guests.length) {
      guests.removeAt(index);
      updateTableStatics();
    }
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
