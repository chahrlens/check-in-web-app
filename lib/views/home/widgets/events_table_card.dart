import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/widgets/datatable/common_data_table.dart';
import 'package:qr_check_in/views/home/controllers/home_controller.dart';
import 'package:qr_check_in/widgets/datatable/custom_data_table_widget_v2.dart';
import 'package:qr_check_in/services/qr_print_service.dart';

class EventsTableCard extends StatelessWidget {
  const EventsTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return CustomDataTableWidgetV2(
        columnSizes: <ColumnSize>[
          ColumnSize.S,
          ColumnSize.L,
          ColumnSize.M,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.S,
          ColumnSize.M,
        ],
        tableHeaders: <String>[
          'ID',
          'Anfitrión',
          'Descripción',
          'Total espacios',
          'Total mesas',
          'Total Reservaciones',
          'Total sin reservar',
          'Ingresados',
          'Disponibles',
          'Fecha',
          'Acciones',
        ],
        tableRows: controller.events
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                DataRow(
                  cells: [
                    cell(item.id.toString().padLeft(4, '0'), context),
                    cell(item.host.fullName, context),
                    cell(item.description, context),
                    cell(item.totalSpaces.toString(), context),
                    cell(item.tableCount.toString(), context),
                    cell(item.reservationCount.toString(), context),
                    cell(item.availableUnAssigned.toString(), context),
                    cell(item.guestEntered.toString(), context),
                    cell(item.availableCount.toString(), context),
                    cell(item.eventDate.toLocal().toString().split(' ')[0], context),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.yellow,
                              ),
                            ),
                            icon: Tooltip(
                              message: 'Editar evento',
                              child: Icon(Icons.edit),
                            ),
                            onPressed: () {
                              Get.toNamed(
                                RouteConstants.manageEvent,
                                arguments: {'isEdit': true, 'data': item},
                              );
                            },
                          ),
                          IconButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.blue,
                              ),
                            ),
                            onPressed: () =>
                                QRPrintService.openPrintWindow(item),
                            icon: const Tooltip(
                              message: 'Imprimir pase a invitados',
                              child: Icon(Icons.print),
                            ),
                          ),
                          IconButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.red,
                              ),
                            ),
                            icon: Tooltip(
                              message: 'Finalizar evento',
                              child: Icon(Icons.check_circle),
                            ),
                            onPressed: () {
                              // Delete action
                            },
                          ),
                          PopupMenuButton<int>(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.add, color: Colors.lightBlue),
                                    SizedBox(width: 8),
                                    Text('Agregar mesas'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_add,
                                      color: Colors.lightBlue,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Agregar invitados'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 1) {
                                Get.toNamed(
                                  RouteConstants.manageEvent,
                                  arguments: {'data': item, 'isEdit': true},
                                );
                              } else if (value == 2) {
                                Get.toNamed(
                                  RouteConstants.manageGuests,
                                  arguments: {'data': item},
                                );
                              }
                            },
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
      );
    });
  }

  DataCell cell(dynamic value, BuildContext context) {
    return cellDataTable(value, context: context);
  }
}
