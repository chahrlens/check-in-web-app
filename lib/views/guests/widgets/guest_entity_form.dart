import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/widgets/inputs/dropdown_widget_v2.dart';
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
                    GenericLoadingAutocompleteDropdown<EventTable>(
                      isLoading: controller.isLoading,
                      controller: controller.eventTableCtrl,
                      items: controller.eventTables,
                      label: 'Seleccionar Mesa',
                      hintText: 'Selecciona una mesa',
                      resetValue: controller.selectedTable,
                      width: width,
                      enabled: true,
                      prefixIcon: Icons.table_chart,
                      onSelected: (table) {
                        controller.setSelectedTable(table);
                      },
                    ),
                    CustomInputWidget(
                      width: width,
                      controller: controller.tableSpaces,
                      label: 'Espacios en la Mesa',
                      hintText: 'Espacios en la mesa',
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
                      controller: controller.tableSpaceReservations,
                      label: 'Espacios a reservar',
                      hintText: 'Ingresa los espacios a reservar',
                      prefixIcon: Icons.event_available,
                      enabled: controller.isInputEnabled,
                      validator: controller.validateSpacesToReserve,
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
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.appendReservation();
                    } else {
                      controller.autoValidateMode = true;
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
