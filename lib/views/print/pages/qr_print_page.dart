import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/views/print/widgets/print_card_widget.dart';
import 'package:qr_check_in/views/print/controllers/qr_print_controller.dart';

class QRPrintPage extends StatefulWidget {
  const QRPrintPage({super.key});

  @override
  State<QRPrintPage> createState() => _QRPrintPageState();
}

class _QRPrintPageState extends State<QRPrintPage> {
  late QrPrintController _controller;

  final args = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();
    _controller = Get.put(QrPrintController());
    _controller.setData(args);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Imprimir QR',
      description: 'Imprime los códigos QR organizados por mesa',
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
                  title: 'Reservaciones',
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 150.0,
                    child: Obx(() {
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
                              .where((r) => r.tableId == selectedTable.id)
                              .toList() ??
                          [];
                      if (reservations.isEmpty) {
                        return Center(
                          child: Text('No hay reservaciones para esta mesa.'),
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
                              child: PrintCardWidget(reservation: reservation),
                            );
                          }).toList(),
                        ),
                      );
                    }),
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
