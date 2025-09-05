import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/guests/controllers/guest_controller.dart';

class GuestEntityForm extends StatelessWidget {
  GuestEntityForm({super.key, required this.width});

  final double width;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageGuestController>(
      builder: (controller) {
        return Column(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: controller.autoValidateMode
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 12,
                  children: [
                    CustomInputWidget(
                      width: width,
                      controller: controller.tableSpaces,
                      label: 'Espacios totales en la Mesa',
                      hintText: 'Espacios totales en la mesa',
                      prefixIcon: Icons.event_seat,
                      enabled: false,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.tableUsedSpaces,
                      label: 'Espacios reservados',
                      hintText: 'Espacios reservados',
                      prefixIcon: Icons.event_busy,
                      enabled: false,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.tableAvailableSpace,
                      label: 'Espacios disponibles',
                      hintText: 'Espacios disponibles',
                      prefixIcon: Icons.event_available,
                      validator: controller.validateSpacesToReserve,
                      enabled: false,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.guestName,
                      label: 'Nombre del Invitado',
                      hintText: 'Ingresa el nombre del invitado',
                      prefixIcon: Icons.person,
                      enabled: controller.isInputEnabled,
                      validator: controller.validateGuestName,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.guestLastName,
                      label: 'Apellido del Invitado',
                      hintText: 'Ingresa el apellido del invitado',
                      prefixIcon: Icons.person,
                      enabled: controller.isInputEnabled,
                      validator: controller.validateGuestLastName,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.phone,
                      label: 'Teléfono',
                      hintText: '+502-XXX-XXX-XXXX',
                      prefixIcon: Icons.phone,
                      enabled: controller.isInputEnabled,
                      validator: controller.validatePhone,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.dpi,
                      label: 'DPI (Opcional)',
                      hintText: 'Ingresa el DPI (13 dígitos)',
                      prefixIcon: Icons.credit_card,
                      enabled: controller.isInputEnabled,
                      validator: controller.validateDPI,
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.nit,
                      label: 'NIT (Opcional)',
                      hintText: 'Ej: XXXXXX-X o XXXXXX-K',
                      prefixIcon: Icons.business,
                      enabled: controller.isInputEnabled,
                      validator: controller.validateNIT,
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: width,
              padding: const EdgeInsets.only(top: 18),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    final isAnonymous = controller.isAnonymous();
                    final bool hasGuests = controller.guests.isNotEmpty;
                    // Validar si el campo de espacios disponibles llega a cero
                    final availableSpaces =
                        int.tryParse(controller.tableAvailableSpace.text) ?? 0;
                    if (availableSpaces <= 0) {
                      ToastService.warning(
                        title: "Advertencia",
                        message:
                            "No se pueden agregar más invitados, la lista de espacios está vacía.",
                      );
                      return;
                    }
                    // Si es anónimo y ya tiene invitados o si hay una reserva seleccionada, no validar el formulario
                    if (isAnonymous && hasGuests ||
                        controller.selectedReservation != null) {
                      if (controller.isInputEnabled) {
                        controller.appendData();
                      }
                    } else {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.appendData();
                      } else {
                        controller.autoValidateMode = true;
                      }
                    }
                    controller.update();
                  },
                  child: Text('Reservar'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
