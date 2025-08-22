import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class CustomPaginatedDataTableWidget<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final List<DataRow> Function(List<T> paginatedData) buildRows;
  final int rowsPerPage;
  final Color? headingColor;
  final double minWidth;
  final double tableHeight;
  final int initialPage;

  const CustomPaginatedDataTableWidget({
    super.key,
    required this.data,
    required this.columns,
    required this.buildRows,
    this.rowsPerPage = 10,
    this.headingColor,
    this.minWidth = 1350.0,
    this.tableHeight = 0.6,
    this.initialPage = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * tableHeight,
          child: PaginatedDataTable2(
            source: _LocalDataSource<T>(
              data: data,
              buildRowList: buildRows,
              columnsCount: columns.length,
            ),
            rowsPerPage: rowsPerPage,
            columns: columns,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: minWidth,
            headingRowColor: WidgetStateProperty.all(
              headingColor ?? colorScheme.surfaceContainerHighest,
            ),
            showCheckboxColumn: false,
            dividerThickness: 0,
          ),
        );
      },
    );
  }
}

// DataTableSource genérico para datos locales
class _LocalDataSource<T> extends DataTableSource {
  final List<T> data;
  final List<DataRow> Function(List<T>) buildRowList;
  final int columnsCount;

  _LocalDataSource({
    required this.data,
    required this.buildRowList,
    required this.columnsCount,
  });

  late final List<DataRow> _rows = buildRowList(data);

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) return null;
    return _rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}
