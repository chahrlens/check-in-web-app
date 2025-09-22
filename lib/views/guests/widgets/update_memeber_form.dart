import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/guests/controllers/update_member_controller.dart';

class UpdateMemberFormWidget extends StatelessWidget {
  const UpdateMemberFormWidget({
    super.key,
    required this.formKey,
    required this.inputWidth,
  });

  final GlobalKey<FormState> formKey;
  final double inputWidth;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateMemberController>(
      builder: (controller) {
        if (!controller.showForm) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 200,
              minWidth: double.infinity,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Escanea un código QR o ingresa un código para cargar los datos del miembro',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Form(
          key: formKey,
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.center,
              children: [
                CustomInputWidget(
                  controller: controller.firstName,
                  label: 'Nombres',
                  hintText: 'Ingrese los nombres',
                  width: inputWidth,
                  prefixIcon: Icons.person,
                  validator: controller.validateGuestName,
                ),
                CustomInputWidget(
                  controller: controller.lastName,
                  label: 'Apellidos',
                  hintText: 'Ingrese los apellidos',
                  width: inputWidth,
                  prefixIcon: Icons.person,
                  validator: controller.validateGuestLastName,
                ),
                CustomInputWidget(
                  controller: controller.dpi,
                  label: 'DPI',
                  hintText: 'Ingrese el DPI',
                  width: inputWidth,
                  prefixIcon: Icons.badge,
                  validator: controller.validateDPI,
                ),
                CustomInputWidget(
                  controller: controller.nit,
                  label: 'NIT',
                  hintText: 'Ingrese el NIT',
                  width: inputWidth,
                  validator: controller.validateNIT,
                  prefixIcon: Icons.confirmation_number,
                ),
                CustomInputWidget(
                  controller: controller.phone,
                  label: 'Teléfono',
                  hintText: 'Ingrese el teléfono',
                  width: inputWidth,
                  prefixIcon: Icons.phone,
                  validator: controller.validatePhone,
                ),
                CustomInputWidget(
                  controller: controller.email,
                  label: 'Correo Electrónico',
                  hintText: 'Ingrese el correo electrónico',
                  width: inputWidth,
                  prefixIcon: Icons.email,
                  validator: controller.validateEmail,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
