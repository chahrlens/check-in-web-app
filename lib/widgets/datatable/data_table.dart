import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/responsive.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

class CustomDataTable<T> extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> elements;
  final bool isHeaderWidgets;
  final List<Widget> headerWidgets;

  const CustomDataTable({super.key,
    required this.columns,
    required this.elements,
    this.isHeaderWidgets = false,
    this.headerWidgets = const [],
  });

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return DataTable(
        columnSpacing: 30.0,
        dataRowMinHeight: 40,
        dataRowMaxHeight: double.infinity,
        showCheckboxColumn: false,
        headingRowHeight: responsive.hp(6),
        headingRowColor: WidgetStateProperty.all<Color>(colorScheme.surface),
        columns: isHeaderWidgets
            ? List.generate(headerWidgets.length,
                (index) => DataColumn(label: headerWidgets[index]))
            : List.generate(
                columns.length,
                (index) => DataColumn(
                  label: Text(
                    columns[index],
                    style: CustomStyle.tableHeader(context, 20.0),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                  ),
                ),
              ),
        rows: elements);
  }
}
