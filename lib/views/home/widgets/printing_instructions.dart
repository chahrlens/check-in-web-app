import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/views/home/controllers/home_controller.dart';

class PrintingInstructions extends StatelessWidget {
  const PrintingInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    controller.printBackground.value =
        true; // Reset a el estado al abrir el modal
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Para obtener los mejores resultados, siga estas instrucciones:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.browser_updated, color: Colors.blue),
            dense: true,
            title: Text('Utilice Google Chrome para mejores resultados'),
          ),
          ListTile(
            leading: Icon(Icons.crop_free, color: Colors.blue),
            dense: true,
            title: Text(
              'Seleccione "Sin márgenes" o "Ninguno" en la configuración de impresión',
            ),
          ),
          ListTile(
            leading: Icon(Icons.description, color: Colors.blue),
            dense: true,
            title: Text('Verifique que el tamaño de papel sea Carta/Letter'),
          ),
          ListTile(
            leading: Icon(Icons.screen_rotation, color: Colors.blue),
            dense: true,
            title: Text('Configure orientación Horizontal/Landscape'),
          ),
          ListTile(
            leading: Icon(Icons.format_indent_decrease, color: Colors.blue),
            dense: true,
            title: Text('Desactive la opción "Encabezados y pies de página"'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nota: Cada página mostrará 2 invitaciones correctamente formateadas.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                '¿Desea imprimir con fondo?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              Obx(
                () => Column(
                  children: [
                    Text(
                      controller.printBackground.value ? 'Sí' : 'No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: controller.printBackground.value
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Switch(
                      value: controller.printBackground.value,
                      onChanged: (value) {
                        controller.printBackground.value = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
