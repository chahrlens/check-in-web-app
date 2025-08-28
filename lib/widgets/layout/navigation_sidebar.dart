import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/controllers/sidebar/menu_sidebar_controller.dart';
import 'package:qr_check_in/controllers/sidebar/sidebar_controller.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';

class NavigationSidebar extends StatelessWidget {
  final String userRole; //! remove this if not needed
  final String? currentRoute;

  const NavigationSidebar({
    super.key,
    required this.userRole,
    this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final MenuSidebarController menuController = Get.find();
    final SidebarController sidebarController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;

    // print(
    //     'userInfo: ${userInfo.username.value}, role: ${userInfo.role.value.name}');

    // Cargar menú si está vacío
    // print("Verificando si el menú está vacío: ${menuController.menu.isEmpty}");
    if (menuController.menu.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // print("Cargando menú desde el controlador");
        // menuController.loadMenu(userInfo.role.value.name);
        menuController.loadMenu('admin');
      });
    }
    return Container(
      width: 250,
      color: colorScheme.surface,
      child: Column(
        children: [
          // AppBar custom
          Container(
            height: kToolbarHeight,
            width: double.infinity,
            color: colorScheme.primary,
            alignment: Alignment.center,
            child: Text(
              "ElEbano",
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Avatar e información
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: colorScheme.primary,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(10),
                    color: colorScheme.surface,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('lib/assets/images/men.png'),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          // '${userInfo.getPerson.firstName} ${userInfo.getPerson.lastName}',
                          'Example user',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          // userInfo.getRole.name,
                          'Example role',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withAlpha(250),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menú dinámico
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: colorScheme.surface),
              child: Obx(() {
                final menu = menuController.menu;

                if (menu.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.dashboard,
                          color: currentRoute == RouteConstants.dashboard
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onPrimary),
                      title: Text(
                        "Tablero",
                        style: TextStyle(
                            color: currentRoute == RouteConstants.dashboard
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.onPrimary),
                      ),
                      selected: currentRoute == RouteConstants.dashboard,
                      selectedTileColor:
                          colorScheme.secondary.withAlpha((0.1 * 255).toInt()),
                      onTap: () {
                        sidebarController.setExpandedGroup(null);
                        if (currentRoute != null) {
                          Get.offAndToNamed(RouteConstants.dashboard);
                        }
                      },
                    ),
                    for (var group in menu)
                      Obx(() {
                        final isExpanded =
                            sidebarController.expandedGroup.value ==
                                group.label;
                        return ExpansionTile(
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (expanded) {
                            sidebarController.setExpandedGroup(
                                expanded ? group.label : null);
                          },
                          title: Text(
                            group.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          children: [
                            for (var item in group.children)
                              ListTile(
                                leading: Icon(
                                  item.icon,
                                  color: currentRoute == item.route
                                      ? colorScheme.secondary
                                      : null,
                                ),
                                title: Text(item.label,
                                    style: currentRoute == item.route
                                        ? TextStyle(
                                            color: colorScheme.secondary)
                                        : null),
                                selected: currentRoute == item.route,
                                // selectedTileColor: colorScheme.secondary,
                                onTap: () {
                                  if (currentRoute != item.route) {
                                    Get.offNamed(item.route);
                                  }
                                },
                              ),
                          ],
                        );
                      }),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Cerrar sesión"),
                      onTap: () {
                        // lógica logout
                        Get.find<SessionController>().logOut();
                        // Get.offAllNamed('/');
                        Get.offAndToNamed(RouteConstants.login);
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
