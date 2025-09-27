import 'package:get/get.dart';
import 'package:qr_check_in/views/home/pages/home_page.dart';
import 'package:qr_check_in/views/guests/pages/guest_page.dart';
import 'package:qr_check_in/views/login/pages/login_screen.dart';
import 'package:qr_check_in/views/print/pages/qr_print_page.dart';
import 'package:qr_check_in/shared/middleware/auth_middleware.dart';
import 'package:qr_check_in/views/guests/pages/list_guest_page.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';
import 'package:qr_check_in/views/check_in/pages/check_in_page.dart';
import 'package:qr_check_in/views/manage_event/pages/event_page.dart';
import 'package:qr_check_in/views/guests/pages/update_member_page.dart';
import 'package:qr_check_in/views/remove_passes/pages/remove_passes_page.dart';
import 'package:qr_check_in/views/bulk_upload_guests/pages/guest_upload_page.dart';

// ignore: non_constant_identifier_names
final List<GetPage<dynamic>> PRIMARY_ROUTING_PATHS = [
  GetPage(
    name: RouteConstants.login,
    page: () => const LoginPage(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.dashboard,
    page: () => const HomePage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.manageEvent,
    page: () => const ManageEventPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.manageGuests,
    page: () => const ManageGuestsPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.checkIn,
    page: () => const CheckInPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.printInvitations,
    page: () => const QRPrintPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.removePasses,
    page: () => const RemovePassesPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.listGuests,
    page: () => const ListGuestPage(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: RouteConstants.updatePerson,
    page: () => const UpdateMemberPage(),
  ),
  GetPage(
    name: RouteConstants.bulkUploadGuests,
    page: () => const GuestsUploadPage(),
    middlewares: [AuthMiddleware()],
    transition: Transition.fadeIn,
  )
];
