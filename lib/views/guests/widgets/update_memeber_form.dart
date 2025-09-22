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
            child: const Center(
              child: Text('Escanee un código QR para actualizar un invitado'),
            ),
          );
        }
        return Form(
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
                ),
                CustomInputWidget(
                  controller: controller.lastName,
                  label: 'Apellidos',
                  hintText: 'Ingrese los apellidos',
                  width: inputWidth,
                  prefixIcon: Icons.person,
                ),
                CustomInputWidget(
                  controller: controller.dpi,
                  label: 'DPI',
                  hintText: 'Ingrese el DPI',
                  width: inputWidth,
                  prefixIcon: Icons.badge,
                ),
                CustomInputWidget(
                  controller: controller.nit,
                  label: 'NIT',
                  hintText: 'Ingrese el NIT',
                  width: inputWidth,
                  prefixIcon: Icons.confirmation_number,
                ),
                CustomInputWidget(
                  controller: controller.phone,
                  label: 'Teléfono',
                  hintText: 'Ingrese el teléfono',
                  width: inputWidth,
                  prefixIcon: Icons.phone,
                ),
                CustomInputWidget(
                  controller: controller.email,
                  label: 'Correo Electrónico',
                  hintText: 'Ingrese el correo electrónico',
                  width: inputWidth,
                  prefixIcon: Icons.email,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
