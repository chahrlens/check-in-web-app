import 'package:flutter/material.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/theme/theme_extensions.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:qr_check_in/widgets/datatable/common_data_table.dart';
import 'package:qr_check_in/widgets/datatable/custom_data_table_widget_v2.dart';
import 'package:qr_check_in/views/bulk_upload_guests/controllers/guest_upload_controller.dart';

class TableDetail extends StatefulWidget {
  const TableDetail({super.key});

  @override
  State<TableDetail> createState() => _TableDetailState();
}

class _TableDetailState extends State<TableDetail> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GuestUploadController>(
      builder: (controller) => Column(
        children: [
          if (controller.reservationsFiltered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No hay reservaciones para mostrar.'),
            )
          else
            CustomDataTableWidgetV2(
              tableHeaders: const <String>[
                'ID',
                'Familia',
                'Mesa',
                'Nombre',
                'Teléfono',
                'Email',
                'Acciones',
              ],
              tableRows: _buildTableRows(controller),
            ),
        ],
      ),
    );
  }

  List<DataRow> _buildTableRows(GuestUploadController controller) {
    final rows = <DataRow>[];

    // Si no hay reservaciones, retornar lista vacía
    if (controller.reservationsFiltered.isEmpty) {
      return rows;
    }

    // Iterar sobre cada reservación
    int count = 0;
    for (int i = 0; i < controller.reservationsFiltered.length; i++) {
      final EventReservation reservation = controller.reservationsFiltered[i];
      final String familyName = reservation.family.name;
      final List<String> tableNames = _getTableNames(reservation.family);

      // Iterar sobre cada invitado en la reservación
      for (int j = 0; j < reservation.details.length; j++) {
        count++;
        final Guest guest = reservation.details[j];
        rows.add(
          DataRow(
            cells: <DataCell>[
              cell(guest.id),
              cell(familyName),
              cell(tableNames.isEmpty ? '-' : tableNames.join(', ')),
              cell(guest.fullName),
              cell(guest.phone),
              cell(guest.email),
              DataCell(
                IconButton(
                  style: context.deleteButtonStyle,
                  icon: const Tooltip(
                    message: 'Eliminar',
                    child: Icon(Icons.delete),
                  ),
                  onPressed: () {
                    controller.dropGuestFromLists(guest);
                  },
                ),
              ),
            ],
            color: colorRowDataTable(count, context),
          ),
        );
      }
    }

    return rows;
  }

  // Método para obtener los nombres/números de las mesas asignadas a una familia
  List<String> _getTableNames(Family family) {
    if (family.familyTables.isEmpty) {
      return [];
    }

    final tableNames = <String>[];

    for (final familyTable in family.familyTables) {
      if (familyTable.eventTable != null) {
        // Si tenemos acceso al objeto EventTable completo
        final tableName = familyTable.eventTable!.name;
        final tableNumber = familyTable.eventTable!.tableNumber.toString();
        tableNames.add('$tableName ($tableNumber)');
      } else {
        // Si solo tenemos el ID de la mesa
        tableNames.add('Mesa ${familyTable.tableId}');
      }
    }

    return tableNames;
  }

  DataCell cell(dynamic value) {
    return cellDataTable(value, context: context);
  }
}
