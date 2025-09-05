import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/print/controllers/qr_print_controller.dart';

class PrintCardWidget extends StatelessWidget {
  PrintCardWidget({super.key, required this.reservation});

  final ReservationMember reservation;
  final QrPrintController controller = Get.find<QrPrintController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: Colors.white.withValues(alpha: .95),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invitado: ${reservation.member.fullName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Teléfono: ${reservation.member.phone}',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'DPI: ${reservation.member.dpi}',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'NIT: ${reservation.member.nit}',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => controller.printSingleQrCode(reservation),
                icon: Icon(Icons.print, color: Colors.white),
                label: Text('Imprimir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
