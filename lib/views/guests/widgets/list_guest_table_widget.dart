import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:qr_check_in/widgets/datatable/common_data_table.dart';
import 'package:qr_check_in/widgets/datatable/custom_data_table_widget_v2.dart';
import 'package:qr_check_in/views/guests/controllers/list_guest_controller.dart';
import 'package:qr_check_in/views/guests/models/guest_list_item.dart';

class ListGuestTableWidget extends StatefulWidget {
  const ListGuestTableWidget({super.key});

  @override
  State<ListGuestTableWidget> createState() => _ListGuestTableWidgetState();
}

class _ListGuestTableWidgetState extends State<ListGuestTableWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListGuestController>(
      builder: (controller) => SizedBox(
        child: CustomDataTableWidgetV2(
          tableHeaders: const <String>[
            'Código',
            'Familia',
            'Invitado principal',
            'Dpi principal',
            'Invitado',
            'Dpi invitado',
            'Estado',
          ],
          tableRows: buildTableRows(controller.guestItems, context),
        ),
      ),
    );
  }

  List<DataRow> buildTableRows(
    List<GuestListItem> items,
    BuildContext context,
  ) {
    final List<DataRow> rows = [];

    for (int index = 0; index < items.length; index++) {
      final item = items[index];

      rows.add(
        DataRow(
          cells: [
            cell(item.code),
            cell(item.familyName),
            cell(item.mainGuestName),
            cell(item.mainGuestDpi),
            cell(item.memberName),
            cell(item.memberDpi),
            cell(item.attendanceStatus),
          ],
          color: colorRowDataTable(rows.length, context),
        ),
      );
    }

    return rows;
  }

  DataCell cell(dynamic value) {
    return cellDataTable(value, context: context);
  }
}
