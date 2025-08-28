import 'package:get/get.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:qr_check_in/models/menu_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';

class MenuSidebarController extends GetxController {
  var menu = <MenuGroupModel>[].obs;

  void loadMenu(String role) {
    final loader = Get.find<LoaderController>();
    debugLog("Cargando menú para el rol: $role");
    try {
      if (role == 'Administrador') {
        List<MenuGroupModel> result = [];
        menu.assignAll(result);
      } else {
        menu.clear();
      }
    } catch (e) {
      debugLog("Error al cargar el menú: $e");
    } finally {
      loader.hide();

      debugLog("Menú cargado: ${menu.length} grupos");
    }
  }
}
