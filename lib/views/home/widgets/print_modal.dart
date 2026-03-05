import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/services/qr_print_service.dart';
import 'package:qr_check_in/views/home/controllers/home_controller.dart';
import 'package:qr_check_in/views/home/widgets/printing_instructions.dart';

class PrintModal extends StatelessWidget {
  const PrintModal({super.key, required this.eventData});

  final EventModel eventData;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return AlertDialog(
      title: const Text('Instrucciones de Impresión'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrintingInstructions(),
          const SizedBox(height: 16),
          const Text(
            'Selecciona el formato de impresión:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            QRPrintService.openPrintWindow(eventData, showBackground: controller.printBackground.value);
          },
          child: const Text('Imprimir 2 por página'),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            QRPrintService.openPrintWindow(eventData, verticalFormat: true, showBackground: controller.printBackground.value);
          },
          child: const Text('Imprimir 1 por página'),
        ),
      ],
    );
  }
}
