import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

class PaginatedDataTableWidget extends StatefulWidget {
  final List<String> tableHeaders;
  final List<DataRow> tableRows; // Ahora acepta DataRow directamente
  final List<ColumnSize>? columnSizes;
  final List<double?>? fixedColumnWidths;
  final double minWidth;
  final bool showCheckboxColumn;
  final void Function(int columnIndex, bool ascending)? onSort;

  const PaginatedDataTableWidget({
    super.key,
    required this.tableHeaders,
    required this.tableRows,
    this.columnSizes,
    this.fixedColumnWidths,
    this.minWidth = 1350.0,
    this.showCheckboxColumn = false,
    this.onSort,
  });

  @override
  State<PaginatedDataTableWidget> createState() =>
      _PaginatedDataTableWidgetState();
}

class _PaginatedDataTableWidgetState extends State<PaginatedDataTableWidget> {
  final int _rowsPerPage = 100;

  // Convierte List<DataRow> a List<List<String>> extrayendo texto de cada DataCell
  List<List<String>> get _extractedRows {
    return widget.tableRows.map((dataRow) {
      return dataRow.cells.map((dataCell) {
        final widget = dataCell.child;
        if (widget is Text) {
          return widget.data ?? '';
        }
        // Si la celda tiene otro widget, intenta obtener su texto o devuelve vacío
        return '';
      }).toList();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final source = _CustomTableDataSource(
      context: context,
      tableHeaders: widget.tableHeaders,
      rowValues: _extractedRows,
      colorScheme: colorScheme,
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: PaginatedDataTable2(
        columns: _buildColumns(context),
        source: source,
        showCheckboxColumn: widget.showCheckboxColumn,
        headingRowColor:
            WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: widget.minWidth,
        rowsPerPage: _rowsPerPage,
        availableRowsPerPage: const [],
        onRowsPerPageChanged: null,
      ),
    );
  }

  List<DataColumn> _buildColumns(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    double fontSize = (constraints.width * 0.02).clamp(13, 18);

    return List.generate(widget.tableHeaders.length, (index) {
      final columnSize = widget.columnSizes != null &&
              index < widget.columnSizes!.length
          ? widget.columnSizes![index]
          : ColumnSize.M;

      final fixedWidth = widget.fixedColumnWidths != null &&
              index < widget.fixedColumnWidths!.length
          ? widget.fixedColumnWidths![index]
          : null;

      return DataColumn2(
        label: Text(
          widget.tableHeaders[index],
          style: CustomStyle.tableHeader(context, fontSize),
          maxLines: 2,
        ),
        onSort: widget.onSort,
        size: columnSize,
        fixedWidth: fixedWidth,
      );
    });
  }
}

class _CustomTableDataSource extends DataTableSource {
  final List<String> tableHeaders;
  final List<List<String>> rowValues;
  final BuildContext context;
  final ColorScheme colorScheme;

  _CustomTableDataSource({
    required this.context,
    required this.tableHeaders,
    required this.rowValues,
    required this.colorScheme,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= rowValues.length) return null;

    final cells = rowValues[index];

    return DataRow(
      color: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
      cells: List.generate(tableHeaders.length, (i) {
        final text = i < cells.length ? cells[i] : '';
        return DataCell(Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
      }),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rowValues.length;

  @override
  int get selectedRowCount => 0;
}
