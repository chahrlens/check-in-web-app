import 'dart:async';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_check_in/controllers/sidebar/menu_sidebar_controller.dart';
import 'package:qr_check_in/shared/constants/global_keys.dart';
import 'package:qr_check_in/shared/helpers/encryption.dart';
import 'package:qr_check_in/shared/resources/local_storaje.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/views/login/services/login_service.dart';


class SessionController extends GetxController {
  final LocalStorage _storageController = Get.find<LocalStorage>();
  final MenuSidebarController _menuController =
      Get.find<MenuSidebarController>();

  var username = ''.obs;
  var token = ''.obs;
  var userId = 0.obs;


  RxBool isLoading = false.obs;

  bool get isTokenExpired {
    if (token.value.isEmpty) return true;
    return JwtDecoder.isExpired(token.value);
  }

  // Métodos para setear los valores
  void setUsername(String value) {
    username.value = value;
  }

  void setToken(String value) {
    token.value = value;
  }

  void setUserId(int id) {
    userId.value = id;
  }

  // // Método para establecer todo junto (por ejemplo, al hacer login)
  // void setSession(
  //     {required String username,
  //     required String token,
  //     required int userId,
  //     required RoleModel role,
  //     required PersonModel person,
  //     SimpleEntity? group}) {
  //   this.username.value = username;
  //   this.token.value = token;
  //   this.userId.value = userId;
  //   this.role.value = role;
  //   this.person.value = person;
  //   this.group.value = group ?? SimpleEntity(id: "", name: "");
  //   debugLog(
  //       "SessionController: setSession called with username: ${this.group.value.name}, role:");
  // }

  // Métodos para acceder si quieres usar sin `.value`
  String get getUsername => username.value;
  // String get fullName => '${person.value.firstName} ${person.value.lastName}';
  String get getToken => token.value;
  int get getUserId => userId.value;

  Future<void> logOut() async {
    // Aquí puedes limpiar las variables o hacer cualquier otra acción necesaria al cerrar sesión
    username.value = '';
    token.value = '';
    userId.value = 0;
    // role.value = RoleModel(id: 0, name: '');
    // person.value = PersonModel(id: 0, firstName: '', lastName: '');
    // group.value = SimpleEntity(id: "", name: "");

    MenuSidebarController menuController = Get.find();
    menuController.menu.clear();
    //Clear local storage
    await Future.wait([
      _storageController.removeElement(GlobalKeys.tokenKey),
      _storageController.removeElement(GlobalKeys.userIdKey),
    ]);
  }

  Map<String, String> generateEncryptedHeaders() {
    final String bearer = 'bearer $getToken';
    final String encryptedBearer = obfuscateValue(bearer);

    return {
      'Authorization': encryptedBearer,
      'Content-Type': 'application/json',
    };
  }

  bool tokenIsValid(String? token) {
    if (token == null || token.isEmpty) {
      return false;
    }
    bool isExpired = JwtDecoder.isExpired(token);
    return !isExpired;
  }

  @override
  void onInit() {
    super.onInit();
    _getSessionStorage();
  }

  Future<bool> _getSessionStorage() async {
    try {
      if (getUserId != 0) {
        return true;
      }
      isLoading.value = true;
      final LoginService loginService = LoginService();
      final results = await Future.wait([
        _storageController.getString(GlobalKeys.tokenKey),
        _storageController.getString(GlobalKeys.userIdKey),
      ]);
      final sessionToken = results[0];
      final userId = results[1];
      final tokenIsValid = this.tokenIsValid(sessionToken);
      if (tokenIsValid && userId != null) {
        final user = await loginService.retrieveUserData(sessionToken!, userId);
        if (user != null) {
          await _storageController.removeElement(GlobalKeys.tokenKey);
          await _storageController.setStringValues({
            GlobalKeys.tokenKey: user.token,
          });
          // setSession(
          //   username: user.username,
          //   token: sessionToken,
          //   userId: user.id,
          //   role: user.role!,
          //   person: user.person!,
          //   group: user.group!,
          // );
          _menuController.loadMenu(user.role!.name);
          return true;
        }
      }
      return false;
    } catch (e) {
      debugLog('Error in getSessionStorage: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
