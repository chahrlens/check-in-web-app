import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toastification/toastification.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/theme/color_pallete.dart';
import 'package:qr_check_in/services/auth_service.dart';
import 'package:qr_check_in/config/firebase_options.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:qr_check_in/shared/resources/local_storaje.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/shared/resources/get_routes/get_routes.dart';
import 'package:qr_check_in/controllers/sidebar/sidebar_controller.dart';
import 'package:qr_check_in/controllers/sidebar/menu_sidebar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.webOptions);

  Get.put(LocalStorage());
  Get.put(AuthService());
  Get.put(MenuSidebarController());
  Get.put(SidebarController());
  Get.put(LoaderController());
  Get.put(SessionController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        initialRoute: RouteConstants.login,
        title: 'Qr Check In',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        getPages: PRIMARY_ROUTING_PATHS,
        theme: appTheme,
        routingCallback: (routing) {
          if (routing?.current != null) {
            debugPrint('ROUTE CALLED: ${routing?.current}');
          }
        },
      ),
    );
  }
}
