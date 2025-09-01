import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/remove_passes/controllers/remove_passes_controller.dart';

class EventInvitationCard extends StatelessWidget {
  EventInvitationCard({super.key, required this.reservation});

  final Reservation reservation;
  final RemovePassesController controller = Get.find<RemovePassesController>();

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
                onPressed: () =>
                    showDeleteConfirmationDialog(context, reservation),
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text('Eliminar'),
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

  //modal confirmation to delete
  Future<void> showDeleteConfirmationDialog(
    BuildContext context,
    Reservation reservation,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('¿Estás seguro de que deseas eliminar esta mesa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      final result = await controller.deleteElement(reservation);
      if (result) {
        Get.back();
      }
    }
  }
}
