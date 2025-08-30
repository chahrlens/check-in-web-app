import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/views/manage_event/widgets/event_form.dart';
import 'package:qr_check_in/views/manage_event/widgets/table_list_widget.dart';
import 'package:qr_check_in/views/manage_event/controllers/event_controller.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({super.key});

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  late ManageEventController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dynamic args = Get.arguments ?? {};
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ManageEventController());
    if (args != null && args['isEdit'] == true) {
      isEdit = true;
      _controller.setEditMode(args);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: isEdit ? 'Editar Evento' : 'Crear Evento',
      description: 'Gestionar eventos',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                EventForm(formKey: _formKey),
                const SizedBox(height: 12),
                ContentCard(
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 100,
                    child: TableListWidget(formKey: _formKey),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            Get.snackbar(
                              'Error',
                              'Por favor completa todos los campos requeridos para continuar.',
                            );
                            _controller.autovalidateMode = true;
                            _controller.update();
                            return;
                          }
                          final success = await _controller.saveData();
                          if (success && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: Text('Guardar'),
                      ),
                      const SizedBox(width: 48 * 2),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
