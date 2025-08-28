import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/views/manage_event/controllers/event_controller.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';

class ModalTableForm extends StatelessWidget {
  ModalTableForm({super.key});

  final ManageEventController controller = Get.find<ManageEventController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final tableNumberCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    child: Column(
                      children: [
                        CustomInputWidget(
                          controller: nameCtrl,
                          label: 'Nombre',
                          hintText: 'Ingrese el nombre de la mesa',
                          prefixIcon: Icons.table_chart,
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
                        ),
                        CustomInputWidget(
                          controller: capacityCtrl,
                          label: 'Capacidad',
                          hintText: 'Ingrese la capacidad',
                          prefixIcon: Icons.people,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Handle form submission
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
  }
}
