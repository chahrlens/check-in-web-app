import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/widgets/datatable/common_data_table.dart';
import 'package:qr_check_in/views/home/controllers/home_controller.dart';
import 'package:qr_check_in/widgets/datatable/custom_data_table_widget_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _controller;

  void _start() async {
    await _controller.fetchEvents();
  }

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Inicio',
      description: 'Bienvenido a la aplicación de Check-In',
      content: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CustomInputWidget(
                          width: constraints.maxWidth * 1 / 3,
                          controller: _controller.searchCtrl,
                          label: 'Buscar',
                          hintText: 'Ingresa tu búsqueda',
                          prefixIcon: Icons.search,
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _start,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reiniciar'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed(RouteConstants.checkIn);
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Check-In'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ContentCard(
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 300,
                    child: Column(
                      children: [
                        Obx(
                          () => CustomDataTableWidgetV2(
                            columnSizes: <ColumnSize>[
                              ColumnSize.S,
                              ColumnSize.L,
                              ColumnSize.L,
                              ColumnSize.S,
                              ColumnSize.S,
                              ColumnSize.S,
                              ColumnSize.M,
                              ColumnSize.M,
                            ],
                            tableHeaders: <String>[
                              'ID',
                              'Anfitrión',
                              'Descripción',
                              'Total espacios',
                              'Total mesas',
                              'Total Reservaciones',
                              'Fecha',
                              'Acciones',
                            ],
                            tableRows: _controller.events
                                .asMap()
                                .map(
                                  (index, value) => MapEntry(
                                    index,
                                    DataRow(
                                      cells: [
                                        cell(
                                          value.id.toString().padLeft(4, '0'),
                                        ),
                                        cell(value.host.fullName),
                                        cell(value.description),
                                        cell(value.totalSpaces.toString()),
                                        cell(value.tableCount.toString()),
                                        cell(value.reservationCount.toString()),
                                        cell(
                                          value.eventDate.toLocal().toString(),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<
                                                        Color
                                                      >(Colors.yellow),
                                                ),
                                                icon: Tooltip(
                                                  message: 'Editar evento',
                                                  child: Icon(Icons.edit),
                                                ),
                                                onPressed: () {
                                                  // Edit action
                                                },
                                              ),
                                              IconButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<
                                                        Color
                                                      >(Colors.blue),
                                                ),
                                                onPressed: () {},
                                                icon: Tooltip(
                                                  message:
                                                      'Imprimir pase a invitados',
                                                  child: Icon(Icons.print),
                                                ),
                                              ),
                                              IconButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<
                                                        Color
                                                      >(Colors.red),
                                                ),
                                                icon: Tooltip(
                                                  message: 'Finalizar evento',
                                                  child: Icon(
                                                    Icons.check_circle,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // Delete action
                                                },
                                              ),
                                              //More action icon button [Agregar mesas, Agregar invitados]
                                              IconButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all<
                                                        Color
                                                      >(Colors.grey),
                                                ),
                                                onPressed: () {
                                                  
                                                },
                                                icon: Tooltip(
                                                  message:
                                                      'Más acciones\nAgregar mesas, Agregar invitados ',
                                                  child: Icon(Icons.more_vert),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      color: colorRowDataTable(index, context),
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
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

  DataCell cell(dynamic value) {
    return cellDataTable(value, context: context);
  }
}
