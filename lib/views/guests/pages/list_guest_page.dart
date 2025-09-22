import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/widgets/layout/contect_card_space.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/guests/widgets/list_guest_table_widget.dart';
import 'package:qr_check_in/views/guests/controllers/list_guest_controller.dart';

class ListGuestPage extends StatefulWidget {
  const ListGuestPage({super.key});

  @override
  State<ListGuestPage> createState() => _ListGuestPageState();
}

class _ListGuestPageState extends State<ListGuestPage> {
  final TextEditingController _searchController = TextEditingController();
  late ListGuestController _controller;
  final args = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ListGuestController());
    _controller.initialize(args);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Invitados',
      description: 'Lista de invitados al evento',
      showBackButton: true,
      content: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMaximized = constraints.maxWidth > 600;
          final responsiveWidth = isMaximized
              ? (constraints.maxWidth * 1 / 3) * 0.8
              : constraints.maxWidth * 0.8;
          return SingleChildScrollView(
            child: Column(
              children: [
                ContentCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CustomInputWidget(
                          controller: _searchController,
                          label: 'Buscar invitado',
                          hintText: 'Ingrese el nombre o correo del invitado',
                          width: responsiveWidth,
                          prefixIcon: Icons.search,
                          onChange: (value) {
                            _controller.filterData(value);
                          },
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _controller.filterData('');
                            },
                          ),
                        ),
                        // Add more widgets here if needed
                      ],
                    ),
                  ),
                ),
                cardContentSpace(),
                const ContentCard(child: ListGuestTableWidget()),
              ],
            ),
          );
        },
      ),
    );
  }
}
