import 'package:flutter/material.dart';

class PaginatedDataTableRows extends StatefulWidget {
  final List<DataRow> rows;
  final List<DataColumn> columns;
  final int rowsPerPage;
  final void Function(int pageIndex)? onPageChanged;

  const PaginatedDataTableRows({
    super.key,
    required this.rows,
    required this.columns,
    this.rowsPerPage = 10,
    this.onPageChanged,
  });

  @override
  State<PaginatedDataTableRows> createState() => _PaginatedDataTableRowsState();
}

class _PaginatedDataTableRowsState extends State<PaginatedDataTableRows> {
  int _currentPage = 0;

  int get _totalPages => (widget.rows.length / widget.rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final startIndex = _currentPage * widget.rowsPerPage;
    final endIndex = (_currentPage + 1) * widget.rowsPerPage;
    final visibleRows = widget.rows.sublist(
      startIndex,
      endIndex > widget.rows.length ? widget.rows.length : endIndex,
    );

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: widget.columns,
            rows: visibleRows,
            headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerHighest),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${startIndex + 1}-${endIndex > widget.rows.length ? widget.rows.length : endIndex} de ${widget.rows.length}',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPage > 0
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                      widget.onPageChanged?.call(_currentPage);
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentPage < _totalPages - 1
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                      widget.onPageChanged?.call(_currentPage);
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
