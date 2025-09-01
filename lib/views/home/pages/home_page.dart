import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/observers/route_observer.dart';
import 'package:qr_check_in/widgets/layout/content_card.dart';
import 'package:qr_check_in/widgets/commons/fixed_container.dart';
import 'package:qr_check_in/widgets/layout/responsive_layout.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/widgets/inputs/custom_input_widget.dart';
import 'package:qr_check_in/views/home/controllers/home_controller.dart';
import 'package:qr_check_in/views/home/widgets/events_table_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late HomeController _controller;

  void _start() async {
    await _controller.fetchEvents();
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HomeController());
    _start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _start();
    super.didPopNext();
  }

  @override
  void dispose() {
    _controller.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSimpleLayout(
      title: 'Inicio',
      description: 'Bienvenido a la aplicación de Check-In',
      content: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
                      spacing: 20,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CustomInputWidget(
                          width: responsiveWidth,
                          controller: _controller.searchCtrl,
                          label: 'Buscar',
                          hintText: 'Ingresa tu búsqueda',
                          prefixIcon: Icons.search,
                        ),
                        SizedBox(
                          width: responsiveWidth,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Get.toNamed(
                                      RouteConstants.manageEvent,
                                      arguments: {'isEdit': false},
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar evento'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Get.toNamed(RouteConstants.checkIn);
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text('Check-In'),
                                ),
                                const SizedBox(width: 24),
                                ElevatedButton.icon(
                                  onPressed: _start,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Reiniciar'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ContentCard(
                  child: FixedContainer(
                    maxWidth: double.infinity,
                    minWidth: 0.0,
                    minHeight: 300,
                    child: const EventsTableCard(),
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
