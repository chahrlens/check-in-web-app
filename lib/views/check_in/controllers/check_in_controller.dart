import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class UserCheckIn {
  int id;
  String name;
  String email;
  UserCheckIn({required this.id, required this.name, required this.email});
}

class CheckInController extends GetxController {
  final userName = TextEditingController(text: 'Jon Doe');
  final tableNumber = TextEditingController(text: 'Mesa 1');
  final quantityAvailable = TextEditingController(text: '10');
  final quantity = TextEditingController(text: '');

  UserCheckIn? selectedElement;

  /// Simula escaneo de QR y consulta en base de datos
  Future<void> scanQrAndFetchData(BuildContext context) async {
    // Aquí deberías integrar el paquete de escaneo de QR y la consulta real a la base de datos
    // Simulación de datos obtenidos
    final qrData = await _scanQr(context);
    if (qrData == null) return;
    // Simula consulta a base de datos
    final user = await _fetchUserByQr(qrData);
    if (user != null) {
      userName.text = user.name;
      quantityAvailable.text = user.entriesAvailable.toString();
      tableNumber.text = user.tableNumber;
      selectedElement = UserCheckIn(
        id: user.id,
        name: user.name,
        email: user.email,
      );
    } else {
      userName.clear();
      quantityAvailable.clear();
      tableNumber.clear();
      selectedElement = null;
      _showMessage(context, 'QR no válido o invitado no encontrado');
    }
  }

  /// Simula el proceso de check-in y actualización en base de datos
  Future<bool> performCheckIn(BuildContext context) async {
    if (selectedElement == null) {
      _showMessage(context, 'Primero escanee un QR válido');
      return false;
    }
    final qty = int.tryParse(quantity.text) ?? 0;
    final available = int.tryParse(quantityAvailable.text) ?? 0;
    if (qty <= 0 || qty > available) {
      _showMessage(context, 'Cantidad inválida o excede las disponibles');
      return false;
    }
    // Simula actualización en base de datos
    final success = await _updateEntries(selectedElement!.id, qty);
    if (success) {
      quantityAvailable.text = (available - qty).toString();
      _showMessage(context, 'Check-In realizado con éxito');
      return true;
    } else {
      _showMessage(context, 'Error al realizar Check-In');
      return false;
    }
  }

  // Métodos simulados para ejemplo
  Future<String?> _scanQr(BuildContext context) async {
    // Aquí deberías usar un paquete como qr_code_scanner
    // Simulación: retorna un string de QR
    // Puedes mostrar un dialog para simular el escaneo
    return await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Simular escaneo QR'),
        content: const Text('Ingresa el código QR:'),
        actions: [
          TextField(
            autofocus: true,
            onSubmitted: (value) => Navigator.of(ctx).pop(value),
          ),
        ],
      ),
    );
  }

  Future<_UserData?> _fetchUserByQr(String qr) async {
    // Simula consulta a base de datos
    // Reemplaza por tu lógica real
    if (qr == '12345') {
      return _UserData(
        id: 1,
        name: 'Juan Pérez',
        email: 'juan@example.com',
        entriesAvailable: 5,
        tableNumber: 'Mesa 7',
      );
    }
    return null;
  }

  Future<bool> _updateEntries(int userId, int qty) async {
    // Simula actualización en base de datos
    // Reemplaza por tu lógica real
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

}

class _UserData {
  final int id;
  final String name;
  final String email;
  final int entriesAvailable;
  final String tableNumber;
  _UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.entriesAvailable,
    required this.tableNumber,
  });
}
