import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/check_in/controllers/check_in_controller.dart';
import 'package:qr_check_in/views/check_in/pages/qr_scanner_page.dart';
import 'package:qr_check_in/views/check_in/pages/manual_input_dialog.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage>
    with SingleTickerProviderStateMixin {
  final CheckInController _controller = Get.put(CheckInController());
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get _isDesktop {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    Get.delete<CheckInController>();
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
          return Obx(() {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQrInputOptions(context),
                              if (_controller.isLoading.value)
                                const CircularProgressIndicator(),
                            ],
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
                              hintText: 'Nombre del invitado',
                              prefixIcon: Icons.person,
                              readOnly: true,
                            ),
                            CustomInputWidget(
                              width: firstInputsWidth,
                              controller: _controller.guestDpi,
                              label: 'DPI',
                              hintText: 'DPI del invitado',
                              prefixIcon: Icons.badge,
                              readOnly: true,
                            ),
                            CustomInputWidget(
                              width: firstInputsWidth,
                              controller: _controller.guestPhone,
                              label: 'Teléfono',
                              hintText: 'Teléfono del invitado',
                              prefixIcon: Icons.phone,
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
                            CustomInputWidget(
                              width: firstInputsWidth,
                              controller: _controller.reservedSpaces,
                              label: 'Espacios reservados',
                              hintText: 'Número de espacios reservados',
                              prefixIcon: Icons.confirmation_number,
                              readOnly: true,
                            ),
                            CustomInputWidget(
                              width: firstInputsWidth,
                              controller: _controller.quantityAvailable,
                              label: 'Espacios Disponibles',
                              hintText: 'Entradas disponibles',
                              prefixIcon: Icons.confirmation_number,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 100,
                    child: ContentCard(
                      child: Form(
                        key: _formKey,
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: _controller.checkInData == null
                              ? []
                              : [
                                  CustomInputWidget(
                                    width: firstInputsWidth,
                                    controller: _controller.quantity,
                                    label: 'Acompañantes a ingresar',
                                    hintText:
                                        'Ingrese cantidad de acompañantes',
                                    prefixIcon: Icons.confirmation_number,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Ingrese la cantidad';
                                      }
                                      final available = _controller
                                          .checkInData!
                                          .companions
                                          .remaining;
                                      final quantity = int.tryParse(value);
                                      if (quantity == null || quantity <= 0) {
                                        return 'Cantidad inválida';
                                      }
                                      if (quantity > available) {
                                        return 'Cantidad excede las disponibles';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    width: firstInputsWidth * 1 / 2,
                                    child: Obx(() {
                                      return CheckboxListTile(
                                        title: const Text(
                                          'Ingresa invitado principal',
                                        ),
                                        enabled:
                                            !_controller.guestIsArrived.value,
                                        value: _controller.guestEntered.value,
                                        onChanged: (value) {
                                          _controller.guestEntered.value =
                                              value ?? false;
                                        },
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 10, height: 10),
                                  ElevatedButton.icon(
                                    onPressed: _controller.isLoading.value
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final success = await _controller
                                                  .performCheckIn(context);
                                              if (success && context.mounted) {
                                                _controller.clearFields();
                                              }
                                            }
                                          },
                                    icon: const Icon(Icons.check),
                                    label: const Text('Realizar Check-In'),
                                  ),
                                  // Estado del invitado principal
                                  if (_controller.checkInData != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            _controller
                                                .checkInData!
                                                .guest
                                                .hasEntered
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _controller
                                                .checkInData!
                                                .guest
                                                .hasEntered
                                            ? 'Invitado principal: Ya ingresó'
                                            : 'Invitado principal: Pendiente de ingreso',
                                        style: TextStyle(
                                          color:
                                              _controller
                                                  .checkInData!
                                                  .guest
                                                  .hasEntered
                                              ? Colors.green.shade800
                                              : Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildQrInputOptions(BuildContext context) {
    if (_isDesktop) {
      return Row(
        children: [
          ElevatedButton.icon(
            onPressed: _controller.isLoading.value
                ? null
                : () => _openQrScanner(context),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Escanear con Webcam'),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: _controller.isLoading.value
                ? null
                : () => _showManualInputDialog(context),
            icon: const Icon(Icons.keyboard),
            label: const Text(
              'Ingresar Código',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          ElevatedButton.icon(
            onPressed: _controller.isLoading.value
                ? null
                : () => _openQrScanner(context),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Escanear QR'),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: _controller.isLoading.value
                ? null
                : () => _showManualInputDialog(context),
            icon: const Icon(Icons.keyboard),
            tooltip: 'Ingresar código manualmente',
          ),
        ],
      );
    }
  }

  Future<void> _openQrScanner(BuildContext context) async {
    final qrResult = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (qrResult != null && qrResult.isNotEmpty) {
      await _controller.processQrCode(qrResult, context);
      setState(() {});
    }
  }

  Future<void> _showManualInputDialog(BuildContext context) async {
    final qrResult = await showDialog<String>(
      context: context,
      builder: (context) => const ManualInputDialog(),
    );

    if (qrResult != null && qrResult.isNotEmpty) {
      // Procesar el código ingresado manualmente
      await _controller.processQrCode(qrResult, context);
      setState(() {});
    }
  }
}
