import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/guests/controllers/guest_controller.dart';

class HostEntityForm extends StatelessWidget {
  const HostEntityForm({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageGuestController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 12,
            children: [
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.hostName,
                label: 'Nombre del Anfitrión',
                hintText: 'Ingresa el nombre del anfitrión',
                prefixIcon: Icons.person,
              ),
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.eventName,
                label: 'Nombre del Evento',
                hintText: 'Ingresa el nombre del evento',
                prefixIcon: Icons.event,
              ),
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.totalSpaces,
                label: 'Total de Espacios',
                hintText: 'Ingresa el total de espacios',
                prefixIcon: Icons.event_seat,
              ),
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.totalTables,
                label: 'Total de Mesas',
                hintText: 'Ingresa el total de mesas',
                prefixIcon: Icons.table_chart,
              ),
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.reservedSpaces,
                label: 'Espacios Reservados',
                hintText: 'Ingresa los espacios reservados',
                prefixIcon: Icons.event_busy,
              ),
              CustomInputWidget(
                width: width,
                readOnly: true,
                controller: controller.availableSpaces,
                label: 'Espacios Disponibles',
                hintText: 'Ingresa los espacios disponibles',
                prefixIcon: Icons.event_available,
              ),
            ],
          ),
        );
      },
    );
  }
}
