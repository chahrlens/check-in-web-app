import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:qr_check_in/models/check_in_model.dart';
import 'package:qr_check_in/services/check_in_service.dart';

class CheckInController extends GetxController {
  final userName = TextEditingController();
  final tableNumber = TextEditingController();
  final quantityAvailable = TextEditingController();
  final quantity = TextEditingController();
  final guestPhone = TextEditingController();
  final guestDpi = TextEditingController();
  final CheckInService _checkInService = CheckInService();

  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Datos del check-in
  CheckInModel? checkInData;
  String? currentQrUuid;

  @override
  void dispose() {
    userName.dispose();
    tableNumber.dispose();
    quantityAvailable.dispose();
    quantity.dispose();
    guestPhone.dispose();
    guestDpi.dispose();
    super.dispose();
  }

  /// Procesa el código QR escaneado y consulta los detalles del check-in
  Future<void> processQrCode(String qrCode, BuildContext context) async {
    try {
      isLoading.value = true;
      currentQrUuid = qrCode;
      clearFields();

      // Llamar al servicio para verificar el QR
      final result = await _checkInService.getCheckInDetails(qrCode);

      if (result.left != null) {
        // La consulta fue exitosa, mostramos los datos
        checkInData = result.left;
        _fillCheckInDataFields();
        hasError.value = false;
      } else {
        // Error al obtener los datos
        checkInData = null;
        hasError.value = true;
        errorMessage.value = result.right.message ?? 'Error desconocido';
        _showMessage(context, result.right.message ?? 'Error desconocido');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error al procesar el código QR: $e';
      _showMessage(context, 'Error al procesar el código QR');
    } finally {
      isLoading.value = false;
    }
  }

  /// Llena los campos con los datos obtenidos del servicio
  void _fillCheckInDataFields() {
    if (checkInData != null) {
      // Datos del invitado principal
      userName.text = checkInData!.guest.name;
      guestPhone.text = checkInData!.guest.phone;
      guestDpi.text = checkInData!.guest.dpi;

      // Datos de la mesa
      tableNumber.text =
          'Mesa ${checkInData!.table.tableNumber} - ${checkInData!.table.name}';

      // Mostrar espacios totales disponibles (no solo acompañantes)
      quantityAvailable.text = checkInData!.totalSpacesRemaining.toString();
    }
  }

  /// Limpia los campos del formulario
  void clearFields() {
    userName.clear();
    tableNumber.clear();
    quantityAvailable.clear();
    quantity.clear();
    guestPhone.clear();
    guestDpi.clear();
    checkInData = null;
  }

  /// Realiza el proceso de check-in
  Future<bool> performCheckIn(BuildContext context) async {
    if (checkInData == null || currentQrUuid == null) {
      _showMessage(context, 'Primero escanee un QR válido');
      return false;
    }

    final qty = int.tryParse(quantity.text) ?? 0;
    final available = checkInData!.companions.remaining;

    if (qty < 0 || qty > available) {
      _showMessage(context, 'Cantidad inválida o excede las disponibles');
      return false;
    }

    try {
      isLoading.value = true;

      // Llamar al servicio para realizar el check-in
      final response = await _checkInService.performCheckIn(
        numCompanionsEntered: qty,
        uuidCode: currentQrUuid!,
        guestEntered: !checkInData!
            .guest
            .hasEntered, // Si no ha entrado, marcamos como entrada
      );

      if (response.success) {
        // Actualizar datos locales después del check-in exitoso
        await _refreshCheckInData();
        _showMessage(context, 'Check-In realizado con éxito');
        return true;
      } else {
        _showMessage(context, response.message ?? 'Error desconocido');
        return false;
      }
    } catch (e) {
      _showMessage(context, 'Error al realizar Check-In: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Actualiza los datos después de un check-in exitoso
  Future<void> _refreshCheckInData() async {
    if (currentQrUuid != null) {
      final result = await _checkInService.getCheckInDetails(currentQrUuid!);
      if (result.left != null) {
        checkInData = result.left;
        _fillCheckInDataFields();
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
