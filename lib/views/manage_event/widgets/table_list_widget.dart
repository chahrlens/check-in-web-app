import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/views/manage_event/widgets/modal_table_form.dart';
import 'package:qr_check_in/views/manage_event/controllers/event_controller.dart';

class TableListWidget extends StatelessWidget {
  const TableListWidget({super.key, required GlobalKey<FormState> formKey})
    : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageEventController>(
      builder: (controller) {
        return Wrap(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  Get.snackbar(
                    'Error',
                    'Por favor completa todos los campos requeridos para continuar.',
                  );
                  controller.autovalidateMode = true;
                  controller.update();
                  return;
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierLabel: 'Agregar mesa',
                  builder: (BuildContext context) {
                    return Dialog(child: ModalTableForm());
                  },
                );
              },
              icon: Icon(Icons.add),
              label: Text('Agregar mesa'),
            ),

            ...List.generate(controller.eventTables.length, (index) {
              final table = controller.eventTables[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 200,
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    table.name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Mesa ${table.tableNumber}\nCapacidad: ${table.capacity}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.removeEventTable(table),
                              constraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
