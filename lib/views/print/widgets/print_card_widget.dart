import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';

class PrintCardWidget extends StatelessWidget {
  const PrintCardWidget({super.key, required this.reservation});

  final Reservation reservation;

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
              'Invitado: ${reservation.guest.fullName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Teléfono: ${reservation.guest.phone}',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'DPI: ${reservation.guest.dpi}',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'NIT: ${reservation.guest.nit}',
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              'Acompañantes: ${reservation.numCompanions}',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción de imprimir aquí
                },
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
