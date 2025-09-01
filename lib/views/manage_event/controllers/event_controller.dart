import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/services/toast_service.dart';

class ManageEventController extends GetxController {
  //Host data controllers
  bool autovalidateMode = false;
  bool modalAutoValidateMode = false;
  final EventService _eventService = EventService();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final roleCtrl = TextEditingController(text: 'host');
  final dpiCtrl = TextEditingController();
  final nitCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  //event data controllers
  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final totalSpacesCtrl = TextEditingController();
  final eventDateCtrl = TextEditingController();

  RxList<EventTable> eventTables = <EventTable>[].obs;

  EventModel? selectedData;

  void setEditMode(dynamic args) {
    if (args['data'] != null && args['data'] is EventModel) {
      selectedData = args['data'];
      //Host data
      firstNameCtrl.text = selectedData!.host.firstName;
      lastNameCtrl.text = selectedData!.host.lastName;
      roleCtrl.text = selectedData!.host.role;
      dpiCtrl.text = selectedData!.host.dpi;
      nitCtrl.text = selectedData!.host.nit;
      phoneCtrl.text = selectedData!.host.phone;

      //Event data
      nameCtrl.text = selectedData!.name;
      descriptionCtrl.text = selectedData!.description;
      totalSpacesCtrl.text = selectedData!.totalSpaces.toString();
      eventDateCtrl.text = selectedData!.eventDate.toLocal().toString();
      eventTables.assignAll(selectedData?.eventTables ?? []);
    } else {
      selectedData = null;
    }
  }

  void appendEventTable({
    required String name,
    String? description,
    required int tableNumber,
    required int capacity,
  }) {
    final newTable = EventTable(
      id: 0,
      eventId: selectedData?.id ?? 0,
      name: name,
      description: description ?? '',
      tableNumber: tableNumber,
      capacity: capacity,
      createdAt: DateTime.now(),
      updatedAt: null,
      status: 1,
    );
    eventTables.add(newTable);
    update();
  }

  Future<void> removeEventTable(EventTable table) async {
    if (table.id != 0) {
      // Aquí iría la lógica para eliminar la mesa del backend si es necesario
    }
    eventTables.remove(table);
    update();
  }

  bool _hasFormChanges() {
    if (selectedData == null) return false;

    return firstNameCtrl.text != selectedData!.host.firstName ||
        lastNameCtrl.text != selectedData!.host.lastName ||
        roleCtrl.text != selectedData!.host.role ||
        dpiCtrl.text != selectedData!.host.dpi ||
        nitCtrl.text != selectedData!.host.nit ||
        phoneCtrl.text != selectedData!.host.phone ||
        nameCtrl.text != selectedData!.name ||
        descriptionCtrl.text != selectedData!.description ||
        totalSpacesCtrl.text != selectedData!.totalSpaces.toString() ||
        eventDateCtrl.text != selectedData!.eventDate.toString();
  }

  bool _hasNewTables() {
    return eventTables.any((table) => table.id == 0);
  }

  Future<bool> addEventTables() async {
    if (!_hasNewTables()) return false;

    final newTables = eventTables.where((table) => table.id == 0).toList();
    final result = await _eventService.addEventTables(
      eventId: selectedData!.id,
      data: newTables,
    );

    if (result.success) {
      ToastService.success(
        title: 'Success',
        message: 'Mesas agregadas correctamente',
      );
      return true;
    } else {
      ToastService.error(
        title: 'Error',
        message: result.message ?? 'Error al agregar mesas',
      );
    }
    return false;
  }

  Future<bool> updateData() async {
    final bool hasFormChanges = _hasFormChanges();
    final bool hasNewTables = _hasNewTables();

    if (!hasFormChanges && !hasNewTables) {
      ToastService.warning(
        title: 'Info',
        message: 'No hay cambios para guardar',
      );
      return false;
    }

    if (hasFormChanges) {
      // Actualizar datos del evento, anfitrión y/o mesas nuevas
      final updatedEvent = EventModel(
        id: selectedData!.id,
        hostId: selectedData!.host.id,
        name: nameCtrl.text,
        guestEntered: 0,
        description: descriptionCtrl.text,
        totalSpaces: int.parse(totalSpacesCtrl.text),
        eventDate: DateTime.parse(eventDateCtrl.text),
        status: selectedData!.status,
        createdAt: selectedData!.createdAt,
        updatedAt: DateTime.now(),
        host: Host(
          id: selectedData!.host.id,
          firstName: firstNameCtrl.text,
          lastName: lastNameCtrl.text,
          role: roleCtrl.text,
          dpi: dpiCtrl.text,
          nit: nitCtrl.text,
          phone: phoneCtrl.text,
          createdAt: selectedData!.host.createdAt,
          updatedAt: DateTime.now(),
        ),
        eventTables: eventTables,
        reservations: selectedData!.reservations,
      );

      final result = await _eventService.updateEvent(data: updatedEvent);
      if (result.success) {
        ToastService.success(
          title: 'Success',
          message: 'Evento actualizado correctamente',
        );
        return true;
      } else {
        ToastService.error(
          title: 'Error',
          message: result.message ?? 'Error al actualizar evento',
        );
      }
    } else {
      return addEventTables();
    }
    return false;
  }

  Future<bool> saveData() async {
    if (selectedData != null) {
      return updateData();
    } else {
      // Create new event
      final newEvent = EventModel(
        id: 0,
        hostId: 0,
        status: 1,
        guestEntered: 0,
        createdAt: DateTime.now(),
        host: Host(
          id: 0,
          firstName: firstNameCtrl.text,
          lastName: lastNameCtrl.text,
          role: roleCtrl.text,
          dpi: dpiCtrl.text,
          nit: nitCtrl.text,
          phone: phoneCtrl.text,
          createdAt: DateTime.now(),
        ),
        name: nameCtrl.text,
        description: descriptionCtrl.text,
        totalSpaces: int.parse(totalSpacesCtrl.text),
        eventDate: DateTime.parse(eventDateCtrl.text),
        eventTables: eventTables.toList(),
        reservations: [],
      );

      final result = await _eventService.createEvent(data: newEvent);
      if (result.success) {
        ToastService.success(
          title: 'Success',
          message: 'Event created successfully',
        );
        return true;
      } else {
        ToastService.error(
          title: 'Error',
          message: result.message ?? 'Unknown error',
        );
      }
    }
    return false;
  }

  // Validator functions
  String? validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    return validateRequiredField(value);
  }

  String? validateLastName(String? value) {
    return validateRequiredField(value);
  }

  String? validateRole(String? value) {
    return validateRequiredField(value);
  }

  String? validateDPI(String? value) {
    if (value == null || value.isEmpty) {
      return null; // DPI no es obligatorio
    }

    // Remover guiones para validar longitud de dígitos
    final dpiDigits = value.replaceAll('-', '');

    if (dpiDigits.length != 13) {
      return 'El DPI debe tener 13 dígitos';
    }

    // Validar formato: puede tener hasta dos guiones
    final validFormat = RegExp(
      r'^\d{1,13}$|^\d{1,6}-\d{1,6}$|^\d{1,4}-\d{1,4}-\d{1,4}$',
    );
    if (!validFormat.hasMatch(value)) {
      return 'Formato de DPI inválido';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }

    final validFormat = RegExp(
      r'^\+?[1-9]\d{0,3}[ -]?\d{4}[ -]?\d{4}$|^\d{4}-?\d{4}$',
    );
    if (!validFormat.hasMatch(value)) {
      return 'Formato de teléfono inválido';
    }

    return null;
  }

  String? validateNIT(String? value) {
    if (value == null || value.isEmpty) {
      return null; // NIT no es obligatorio
    }

    // Validar formato: 5-12 dígitos, puede tener un guion y terminar en K o k
    final validFormat = RegExp(r'^\d{4,11}(-[Kk])?$|^\d{4,11}[Kk]?$');
    if (!validFormat.hasMatch(value)) {
      return 'Formato de NIT inválido';
    }

    // Validar longitud mínima y máxima sin considerar guion y K
    final nitDigits = value.replaceAll(RegExp(r'[-Kk]'), '');
    if (nitDigits.length < 5 || nitDigits.length > 12) {
      return 'El NIT debe tener entre 5 y 12 dígitos';
    }

    return null;
  }

  String? validateTotalSpaces(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }

    final int? totalSpaces = int.tryParse(value);
    if (totalSpaces == null || totalSpaces <= 0) {
      return 'Ingresa un número válido';
    }

    return null;
  }

  String? validateTableSpaces(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    int? spaces = int.tryParse(value);
    if (spaces == null || spaces <= 0) {
      return 'Ingresa un número válido';
    }
    int maxSpaces = int.parse(totalSpacesCtrl.text);
    int usedSpaces = eventTables.fold<int>(
      0,
      (sum, table) => sum + table.capacity,
    );
    if (usedSpaces + spaces > maxSpaces) {
      return 'No puede exceder la capacidad total';
    }

    return null;
  }
}
