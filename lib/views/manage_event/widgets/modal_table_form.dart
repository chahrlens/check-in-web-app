import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/manage_event/controllers/event_controller.dart';

class ModalTableForm extends StatelessWidget {
  ModalTableForm({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final tableNumberCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageEventController>(
      builder: (controller) {
        return FixedContainer(
          maxWidth: 500,
          minWidth: 300,
          maxHeight: 500,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.red,
                        ),
                      ),
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Agregar Mesa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const Divider(),
              const SizedBox(height: 4),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Form(
                        key: formKey,
                        autovalidateMode: controller.modalAutoValidateMode
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            CustomInputWidget(
                              controller: nameCtrl,
                              label: 'Nombre',
                              hintText: 'Ingrese el nombre de la mesa',
                              prefixIcon: Icons.table_chart,
                              validator: controller.validateRequiredField,
                            ),
                            CustomInputWidget(
                              controller: descriptionCtrl,
                              label: 'Descripción',
                              hintText: 'Ingrese una descripción',
                              prefixIcon: Icons.description,
                            ),
                            CustomInputWidget(
                              controller: tableNumberCtrl,
                              label: 'Número de Mesa',
                              hintText: 'Ingrese el número de la mesa',
                              prefixIcon: Icons.confirmation_number,
                              validator: controller.validateRequiredField,
                            ),
                            CustomInputWidget(
                              controller: capacityCtrl,
                              label: 'Capacidad',
                              hintText: 'Ingrese la capacidad',
                              prefixIcon: Icons.people,
                              validator: controller.validateTableSpaces,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (!formKey.currentState!.validate()) {
                                  controller.modalAutoValidateMode = true;
                                  controller.update();
                                  return;
                                }
                                controller.appendEventTable(
                                  name: nameCtrl.text,
                                  description: descriptionCtrl.text,
                                  tableNumber:
                                      int.tryParse(tableNumberCtrl.text) ?? 0,
                                  capacity:
                                      int.tryParse(capacityCtrl.text) ?? 0,
                                );
                                ToastService.success(
                                  title: 'Éxito',
                                  message: 'Mesa agregada correctamente',
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
