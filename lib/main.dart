import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/theme/color_pallete.dart';
import 'package:qr_check_in/observers/route_observer.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:qr_check_in/shared/resources/local_storaje.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/shared/resources/get_routes/get_routes.dart';
import 'package:qr_check_in/controllers/sidebar/sidebar_controller.dart';
import 'package:qr_check_in/controllers/sidebar/menu_sidebar_controller.dart';

void main() {
  Get.put(MenuSidebarController());
  Get.put(SidebarController());
  Get.put(LoaderController());
  Get.put(LocalStorage());
  Get.put(SessionController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        initialRoute: RouteConstants.dashboard,
        navigatorObservers: [routeObserver],
        title: 'Qr Check In',
        debugShowCheckedModeBanner: false,
        getPages: [
          ...PRIMARY_ROUTING_PATHS,
          // Add any additional routes here
        ],
        theme: appTheme,
      ),
    );
  }
}
