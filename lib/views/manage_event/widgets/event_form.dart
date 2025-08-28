import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_check_in/views/manage_event/controllers/event_controller.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/widgets/inputs/date_picker.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';

class EventForm extends StatelessWidget {
  const EventForm({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageEventController>(
      builder: (controller) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isMaximized = constraints.maxWidth > 600;
          final double widthFirstInputs = isMaximized
              ? (constraints.maxWidth * 1 / 2) * 0.85
              : constraints.maxWidth - 8 * 3;
          final double widthSecondInputs = isMaximized
              ? (constraints.maxWidth * 1 / 2) * 0.85
              : constraints.maxWidth - 8 * 3;
          return Form(
            key: formKey,
            autovalidateMode: controller.autovalidateMode
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                ContentCard(
                  title: 'Datos del Anfitrión',
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.firstNameCtrl,
                          label: 'Nombre',
                          hintText: 'Ingresa tu nombre',
                          prefixIcon: Icons.person,
                          validator: controller.validateFirstName,
                        ),
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.lastNameCtrl,
                          label: 'Apellido',
                          hintText: 'Ingresa tu apellido',
                          prefixIcon: Icons.person,
                          validator: controller.validateLastName,
                        ),
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.roleCtrl,
                          label: 'Rol',
                          hintText: 'Ingresa tu rol',
                          prefixIcon: Icons.work,
                          validator: controller.validateRole,
                          enabled: false,
                        ),
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.dpiCtrl,
                          label: 'DPI',
                          hintText: 'Ingresa tu DPI (Opcional)',
                          prefixIcon: Icons.credit_card,
                          validator: controller.validateDPI,
                        ),
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.nitCtrl,
                          label: 'NIT',
                          hintText: 'Ingresa tu NIT (Opcional)',
                          prefixIcon: Icons.business,
                          validator: controller.validateNIT,
                        ),
                        CustomInputWidget(
                          width: widthFirstInputs,
                          controller: controller.phoneCtrl,
                          label: 'Teléfono',
                          hintText: 'Ingresa tu teléfono (+502 0000-0000)',
                          prefixIcon: Icons.phone,
                          validator: controller.validatePhone,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ContentCard(
                  title: 'Datos del Evento',
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CustomInputWidget(
                          width: widthSecondInputs,
                          controller: controller.nameCtrl,
                          label: 'Nombre del Evento',
                          hintText: 'Ingresa el nombre del evento',
                          prefixIcon: Icons.event,
                          validator: controller.validateRequiredField,
                        ),
                        CustomInputWidget(
                          width: widthSecondInputs,
                          controller: controller.descriptionCtrl,
                          label: 'Descripción',
                          hintText: 'Ingresa una descripción',
                          prefixIcon: Icons.description,
                        ),
                        CustomInputWidget(
                          width: widthSecondInputs,
                          controller: controller.totalSpacesCtrl,
                          label: 'Total de Espacios',
                          hintText: 'Ingresa el total de espacios',
                          prefixIcon: Icons.event_seat,
                          validator: controller.validateTotalSpaces,
                        ),
                        SizedBox(
                          width: widthSecondInputs,
                          child: CustomDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 2),
                            ),
                            controller: controller.eventDateCtrl,
                            label: 'Fecha del Evento',
                            hintText: 'Ingresa la fecha del evento',
                            prefixIcon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
