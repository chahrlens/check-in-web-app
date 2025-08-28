import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/guests/controllers/guest_controller.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';

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
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 12,
                      children: [
                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.hostName,
                          label: 'Nombre del Anfitrión',
                          hintText: 'Ingresa el nombre del anfitrión',
                          prefixIcon: Icons.person,
                        ),

                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.eventName,
                          label: 'Nombre del Evento',
                          hintText: 'Ingresa el nombre del evento',
                          prefixIcon: Icons.event,
                        ),
                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.totalSpaces,
                          label: 'Total de Espacios',
                          hintText: 'Ingresa el total de espacios',
                          prefixIcon: Icons.event_seat,
                        ),
                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.totalTables,
                          label: 'Total de Mesas',
                          hintText: 'Ingresa el total de mesas',
                          prefixIcon: Icons.table_chart,
                        ),
                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.reservedSpaces,
                          label: 'Espacios Reservados',
                          hintText: 'Ingresa los espacios reservados',
                          prefixIcon: Icons.event_busy,
                        ),
                        CustomInputWidget(
                          width: width,
                          readOnly: true,
                          controller: _controller.availableSpaces,
                          label: 'Espacios Disponibles',
                          hintText: 'Ingresa los espacios disponibles',
                          prefixIcon: Icons.event_available,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ContentCard(
                  child: Wrap(
                    children: [
                      //dropdown here
                      Obx(() {
                        return DropdownButton<EventTable>(
                          value: _controller.selectedTable.value,
                          hint: Text('Seleccionar Mesa'),
                          items: _controller.eventTables.map((table) {
                            return DropdownMenuItem<EventTable>(
                              value: table,
                              child: Text('Mesa ${table.id}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _controller.selectedTable.value = value;
                          },
                        );
                      }),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.guestName,
                        label: 'Nombre del Invitado',
                        hintText: 'Ingresa el nombre del invitado',
                        prefixIcon: Icons.person,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.guestLastName,
                        label: 'Apellido del Invitado',
                        hintText: 'Ingresa el apellido del invitado',
                        prefixIcon: Icons.person,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.phone,
                        label: 'Teléfono',
                        hintText: 'Ingresa el teléfono',
                        prefixIcon: Icons.phone,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.dpi,
                        label: 'DPI',
                        hintText: 'Ingresa el DPI',
                        prefixIcon: Icons.credit_card,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.nit,
                        label: 'NIT',
                        hintText: 'Ingresa el NIT',
                        prefixIcon: Icons.business,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.tableId,
                        label: 'ID de Mesa',
                        hintText: 'Ingresa el ID de la mesa',
                        prefixIcon: Icons.table_chart,
                      ),
                      CustomInputWidget(
                        width: width,
                        controller: _controller.numCompanions,
                        label: 'Número de Acompañantes',
                        hintText: 'Ingresa el número de acompañantes',
                        prefixIcon: Icons.group,
                      ),
                      //button here
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        child: Text('Reservar'),
                      ),
                    ],
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
