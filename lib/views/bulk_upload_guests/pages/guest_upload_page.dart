import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/theme/theme_extensions.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/widgets/layout/contect_card_space.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/bulk_upload_guests/widgets/table_detail.dart';
import 'package:qr_check_in/views/bulk_upload_guests/widgets/summary_form.dart';
import 'package:qr_check_in/views/bulk_upload_guests/controllers/guest_upload_controller.dart';

class GuestsUploadPage extends StatefulWidget {
  const GuestsUploadPage({super.key});

  @override
  State<GuestsUploadPage> createState() => _GuestsUploadPageState();
}

class _GuestsUploadPageState extends State<GuestsUploadPage> {
  late GuestUploadController _controller;
  final args = Get.arguments ?? {};

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(GuestUploadController());
    _controller.setEventData(args);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Carga Masiva de Invitados',
      description:
          'Sube un archivo xlsx para agregar múltiples invitados a tu evento.',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMaximized = constraints.maxWidth > 600;
          final double cardWidth = isMaximized
              ? (constraints.maxWidth * 1 / 3) * 0.8
              : constraints.maxWidth * 0.8;
          final double cardContentWidth = isMaximized
              ? (constraints.maxWidth * 1 / 2) * 0.8
              : constraints.maxWidth * 0.8;
          final double cardDetailWidth = isMaximized
              ? (constraints.maxWidth * 1 / 4) * 0.8
              : constraints.maxWidth * 0.8;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.center,
                      children: [
                        CustomInputWidget(
                          width: cardWidth,
                          controller: _searchController,
                          label: 'Buscar',
                          hintText: 'Buscar invitado',
                          prefixIcon: Icons.search,
                          onChange: (query) => _controller.filterGuest(query),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _controller.filterGuest('');
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: ElevatedButton.icon(
                            style: context.elevatedPrimaryButtonStyle,
                            onPressed: () async {
                              final result = await _controller.handleUpload();
                              if (result != null) {
                                ToastService.error(
                                  title: 'Error',
                                  message: result,
                                );
                              } else {
                                ToastService.success(
                                  title: 'Éxito',
                                  message: 'Archivo cargado correctamente',
                                );
                              }
                            },
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Seleccionar Archivo .xlsx'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                cardContentSpace(),
                ContentCard(
                  title: 'Información del Evento',
                  child: SummaryForm(
                    cardContentWidth: cardContentWidth,
                    cardDetailWidth: cardDetailWidth,
                  ),
                ),
                cardContentSpace(),
                ContentCard(
                  title: 'Detalles',
                  child: FixedContainer(
                    minWidth: 0,
                    maxWidth: double.infinity,
                    minHeight: 100,
                    child: TableDetail(),
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
                      label: const Text('Cancelar'),
                      icon: const Icon(Icons.cancel),
                    ),
                    ElevatedButton.icon(
                      style: context.elevatedPrimaryButtonStyle,
                      onPressed: () async {
                        final result = await _controller.handleSave();
                        if (result != null) {
                          ToastService.error(title: 'Error', message: result);
                        } else {
                          ToastService.success(
                            title: 'Éxito',
                            message: 'Invitados cargados correctamente',
                          );
                          Get.back();
                        }
                      },
                      label: const Text('Guardar'),
                      icon: const Icon(Icons.save),
                    ),
                  ],
                ),
                cardContentSpace(),
              ],
            ),
          );
        },
      ),
    );
  }
}
