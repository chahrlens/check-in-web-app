import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:qr_check_in/models/event_model.dart';

class ManageEventController extends GetxController {
  //Host data controllers
  bool autovalidateMode = false;
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final roleCtrl = TextEditingController(text: 'host');
  final dpiCtrl = TextEditingController();
  final nitCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

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
    final validFormat = RegExp(r'^\d{1,13}$|^\d{1,6}-\d{1,6}$|^\d{1,4}-\d{1,4}-\d{1,4}$');
    if (!validFormat.hasMatch(value)) {
      return 'Formato de DPI inválido';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }


    final validFormat = RegExp(r'^\+?[1-9]\d{0,3}[ -]?\d{4}[ -]?\d{4}$|^\d{4}-?\d{4}$');
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
}
