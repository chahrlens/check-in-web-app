import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/bulk_upload_guests/controllers/guest_upload_controller.dart';

class SummaryForm extends StatelessWidget {
  const SummaryForm({
    super.key,
    required this.cardContentWidth,
    required this.cardDetailWidth,
  });

  final double cardContentWidth;
  final double cardDetailWidth;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestUploadController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            children: [
              CustomInputWidget(
                width: cardContentWidth,
                controller: controller.eventName,
                label: 'Nombre del Evento',
                hintText: 'Nombre del evento',
                prefixIcon: Icons.event,
                readOnly: true,
              ),
              CustomInputWidget(
                width: cardContentWidth,
                controller: controller.hostName,
                label: 'Nombre del Anfitrión',
                hintText: 'Nombre del anfitrión',
                prefixIcon: Icons.person,
                readOnly: true,
              ),
              //1/4 summary info
              CustomInputWidget(
                width: cardDetailWidth,
                controller: controller.totalTables,
                label: 'Mesas Totales',
                hintText: '0',
                prefixIcon: Icons.event_seat,
                readOnly: true,
              ),
              CustomInputWidget(
                width: cardDetailWidth,
                controller: controller.totalCapacity,
                label: 'Capacidad Total',
                hintText: '0',
                prefixIcon: Icons.summarize,
                readOnly: true,
              ),
              CustomInputWidget(
                width: cardDetailWidth,
                controller: controller.totalGuests,
                label: 'Invitados Totales',
                hintText: '0',
                prefixIcon: Icons.group,
                readOnly: true,
              ),
              CustomInputWidget(
                width: cardDetailWidth,
                controller: controller.availableSpaces,
                label: 'Espacios Disponibles',
                hintText: '0',
                prefixIcon: Icons.event_available,
                readOnly: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
