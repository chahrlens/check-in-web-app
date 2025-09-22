import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:qr_check_in/theme/theme_extensions.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/widgets/layout/contect_card_space.dart';
import 'package:qr_check_in/views/check_in/pages/qr_scanner_page.dart';
import 'package:qr_check_in/views/guests/widgets/update_memeber_form.dart';
import 'package:qr_check_in/views/check_in/pages/manual_input_dialog.dart';
import 'package:qr_check_in/views/guests/controllers/update_member_controller.dart';

class UpdateMemberPage extends StatefulWidget {
  const UpdateMemberPage({super.key});

  @override
  State<UpdateMemberPage> createState() => _UpdateMemberPageState();
}

class _UpdateMemberPageState extends State<UpdateMemberPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late UpdateMemberController _controller;
  bool get _isDesktop {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(UpdateMemberController());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Actualizar Miembro',
      description: 'Actualiza la información del miembro aquí.',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          int itemsPerRow;

          if (maxWidth > 1600) {
            itemsPerRow = 3; // Tres inputs en línea para pantallas grandes
          } else if (maxWidth > 800) {
            itemsPerRow = 2; // Dos inputs en línea para pantallas medianas
          } else {
            itemsPerRow = 1; // Un input por línea para pantallas pequeñas
          }

          final double inputWidth = maxWidth / itemsPerRow * 0.9;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  child: SingleChildScrollView(
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
                ),
                cardContentSpace(),
                ContentCard(
                  child: UpdateMemberFormWidget(
                    formKey: _formKey,
                    inputWidth: inputWidth,
                  ),
                ),
                cardContentSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: context.elevatedDeleteButtonStyle,
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Regresar'),
                    ),
                    ElevatedButton.icon(
                      style: context.elevatedPrimaryButtonStyle,
                      onPressed: _controller.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await _controller.updateMember();
                                if (context.mounted && success) {
                                  Get.back();
                                }
                              }
                            },
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
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

    if (context.mounted && qrResult != null && qrResult.isNotEmpty) {
      await _controller.processQrCode(qrResult);
    }
  }

  Future<void> _showManualInputDialog(BuildContext context) async {
    final qrResult = await showDialog<String>(
      context: context,
      builder: (context) => const ManualInputDialog(),
    );

    if (context.mounted && qrResult != null && qrResult.isNotEmpty) {
      await _controller.processQrCode(qrResult);
    }
  }
}
