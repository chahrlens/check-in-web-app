import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/views/guests/widgets/host_widget_form.dart';
import 'package:qr_check_in/views/guests/widgets/guest_entity_form.dart';
import 'package:qr_check_in/views/guests/controllers/guest_controller.dart';

class ManageGuestsPage extends StatefulWidget {
  const ManageGuestsPage({super.key});

  @override
  State<ManageGuestsPage> createState() => _ManageGuestsPageState();
}

class _ManageGuestsPageState extends State<ManageGuestsPage> {
  late ManageGuestController _controller;
  final args = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ManageGuestController());
    _controller.setEventData(args);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Administrar Invitados',
      description: 'Aquí puedes gestionar los invitados para el evento.',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMaximized = constraints.maxHeight > 600;
          final double width = isMaximized
              ? (constraints.maxWidth * 1 / 3) * 0.8
              : constraints.maxWidth;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  title: 'Anfitrión',
                  child: HostEntityForm(width: width),
                ),
                const SizedBox(height: 12),
                ContentCard(
                  title: 'Invitado',
                  child: GuestEntityForm(width: width),
                ),
                const SizedBox(height: 12),
                ContentCard(
                  child: Obx(
                    () => Wrap(
                      children: List.generate(_controller.reservations.length, (
                        index,
                      ) {
                        final reservation = _controller.reservations[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${reservation.guestName} ${reservation.guestLastName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Mesa: ${reservation.table}'),
                                    Text(
                                      'Espacios: ${reservation.totalOccupants}',
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    _controller.reservations.removeAt(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        _controller.cleanGuest();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.cancel),
                      label: Text('Cancelar'),
                    ),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        await _controller.handleSave();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Guardar'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
