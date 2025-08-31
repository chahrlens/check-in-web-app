import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_check_in/controllers/globals.dart';
import 'package:qr_check_in/shared/resources/get_routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final sessionController = Get.find<SessionController>();

    // Si la ruta es login, permitir acceso
    if (route == RouteConstants.login) {
      return null;
    }

    // Verificar si hay token válido
    if (sessionController.getToken.isEmpty || sessionController.isTokenExpired) {
      // Si no hay token o está expirado, redirigir a login
      return const RouteSettings(name: RouteConstants.login);
    }

    // Si hay token válido, permitir acceso
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {}
}
