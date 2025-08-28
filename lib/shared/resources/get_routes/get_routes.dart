import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/views/check_in/pages/check_in_page.dart';
import 'package:qr_check_in/views/home/pages/home_page.dart';

// ignore: non_constant_identifier_names
List<GetPage<dynamic>> PRIMARY_ROUTING_PATHS = [
  GetPage(name: RouteConstants.dashboard, page: () => const HomePage()),
  GetPage(name: RouteConstants.checkIn, page: () => const CheckInPage()),
];
