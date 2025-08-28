import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/check_in/controllers/check_in_controller.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage>
    with SingleTickerProviderStateMixin {
  late CheckInController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CheckInController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Check In',
      description: 'Gestionar entradas',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMaximized = constraints.maxWidth > 600;
          final double firstInputsWidth = isMaximized
              ? (constraints.maxWidth / 3) - 70
              : constraints.maxWidth * 0.8;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _controller.scanQrAndFetchData(context);
                            setState(() {});
                          },
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Escanear QR'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          CustomInputWidget(
                            width: firstInputsWidth,
                            controller: _controller.userName,
                            label: 'Nombre',
                            hintText: 'Ingrese su nombre',
                            prefixIcon: Icons.person,
                            readOnly: true,
                          ),
                          CustomInputWidget(
                            width: firstInputsWidth,
                            controller: _controller.quantityAvailable,
                            label: 'Disponibles',
                            hintText: 'Entradas disponibles',
                            prefixIcon: Icons.confirmation_number,
                            readOnly: true,
                          ),
                          CustomInputWidget(
                            width: firstInputsWidth,
                            controller: _controller.tableNumber,
                            label: 'Mesa',
                            hintText: 'Número de mesa',
                            prefixIcon: Icons.table_restaurant,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ContentCard(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CustomInputWidget(
                        width: firstInputsWidth,
                        controller: _controller.quantity,
                        label: 'Entradas',
                        hintText: 'Ingrese cantidad invitados',
                        prefixIcon: Icons.confirmation_number,
                      ),
                      const SizedBox(width: 10, height: 10),

                      ElevatedButton.icon(
                        onPressed: () async {
                          final success = await _controller.performCheckIn(
                            context,
                          );
                          if (success) setState(() {});
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Realizar Check-In'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
