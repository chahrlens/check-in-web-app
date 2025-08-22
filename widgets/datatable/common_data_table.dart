
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../buttons/custom_elevation_button.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';



DataCell cellDataTable(
  dynamic element, {
  String defaultValue = 'No disponible',
  bool? hasError,
  required BuildContext context,
}) {
  if (element is Widget) {
    return DataCell(element);
  }

  if (element is String && element.length > 25) {
    return _longString(element, hasError, context);
  }

  return DataCell(
    Text(
      element != null ? element.toString() : defaultValue,
      overflow: TextOverflow.ellipsis,
      style: _fontStyleError(context,hasError),
    ),
  );
}

DataCell _longString(String element, bool? hasError, BuildContext context) {
  return DataCell(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Text(
              element,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: _fontStyleError(context, hasError),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            BuildContext? context = Get.context;
            if (context != null && context.mounted) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      width: 400,
                      height: 300,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Descripción',
                              style: CustomStyle.styleBoldMiddle(context),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Expanded(
                            child: Column(
                              children: [
                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      element.toString(),
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: ToolTipButton(
                                    tooltipMessage:
                                        'Copiar texto visible al portapapeles',
                                    label: 'Copiar',
                                    icon: Icons.copy,
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(
                                          text: element.toString(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
          icon: Icon(
            Icons.visibility,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

TextStyle _fontStyleError(BuildContext context, bool? hasError) =>
  TextStyle(
      color: hasError == true ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.w400
      );

  WidgetStateProperty<Color> colorRowDataTable(int index, BuildContext context) {
    return WidgetStateProperty.all<Color>(
      index % 2 == 0 ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.onSecondaryFixedVariant,
    );
  }

