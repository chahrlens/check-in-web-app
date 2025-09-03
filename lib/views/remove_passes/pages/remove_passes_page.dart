import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/card_element.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/views/remove_passes/controllers/remove_passes_controller.dart';

class RemovePassesPage extends StatefulWidget {
  const RemovePassesPage({super.key});

  @override
  State<RemovePassesPage> createState() => _RemovePassesPageState();
}

class _RemovePassesPageState extends State<RemovePassesPage> {
  late RemovePassesController _controller;
  final args = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();
    _controller = Get.put(RemovePassesController());
    _controller.setSelectedEvent(args);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Eliminar Invitación',
      description: 'Esta página te permite eliminar una invitación existente.',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMaximized = constraints.maxWidth > 600;
          final cardWidth = isMaximized
              ? (constraints.maxWidth * 1 / 3) * 0.8
              : constraints.maxWidth * 0.8;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  title: 'Mesas disponibles',
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 100.0,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                            children: _controller.eventTables.map((table) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: ChoiceChip(
                                  label: Text(
                                    table.name,
                                    style: TextStyle(
                                      color:
                                          _controller.selectedTable.value ==
                                              table
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  selected:
                                      _controller.selectedTable.value == table,
                                  selectedColor: Colors.blueAccent,
                                  backgroundColor: Colors.grey[200],
                                  onSelected: (selected) {
                                    if (selected) {
                                      _controller.setSelectedTable(table);
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ContentCard(
                  title: 'Invitados',
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 150.0,
                    child: Column(
                      children: [
                        Obx(() {
                          final selectedTable = _controller.selectedTable.value;
                          if (selectedTable == null) {
                            return Center(
                              child: Text(
                                'Selecciona una mesa para ver sus reservaciones.',
                              ),
                            );
                          }
                          // Filtrar las reservaciones por la mesa seleccionada
                          final reservations =
                              _controller.selectedData?.reservations
                                  .where((r) => r.family.familyTables.map((e) => e.id).contains(selectedTable.id))
                                  .toList() ??
                              [];
                          if (reservations.isEmpty) {
                            return Center(
                              child: Text(
                                'No hay reservaciones para esta mesa.',
                              ),
                            );
                          }
                          return SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.spaceAround,
                              children: reservations.map((reservation) {
                                return SizedBox(
                                  width: cardWidth,
                                  child: EventInvitationCard(
                                    reservation: reservation,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (_controller.selectedTable.value == null) {
                            return const SizedBox.shrink();
                          }
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                                bottom: 16.0,
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    showDeleteConfirmationDialog(context),
                                icon: Icon(Icons.delete, color: Colors.red),
                                label: Text('Eliminar Mesa Completa'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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

  //modal confirmation to delete
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('¿Estás seguro de que deseas eliminar esta mesa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      final result = await _controller.deleteTable();
      if (result) {
        Get.back();
      }
    }
  }
}
