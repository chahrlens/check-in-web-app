import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/services/toast_service.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/check_in_service.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';
import 'package:qr_check_in/views/check_in/controllers/check_in_controller.dart';

class UpdateMemberController extends GetxController {
  final CheckInController checkController = CheckInController();
  final CheckInService _checkInService = CheckInService();
  final LoaderController _loaderController = Get.find<LoaderController>();
  Guest? guest;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final dpi = TextEditingController();
  final nit = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  RxBool isLoading = false.obs;
  bool showForm = false;
  RxBool enableSubmit = false.obs;

  Future<void> processQrCode(String qrCode) async {
    isLoading.value = true;
    _loaderController.show();
    try {
      final result = await _checkInService.getGuestByUuid(qrCode);
      if (result.left != null) {
        guest = result.left;
        firstName.text = guest?.firstName ?? '';
        lastName.text = guest?.lastName ?? '';
        dpi.text = guest?.dpi ?? '';
        nit.text = guest?.nit ?? '';
        phone.text = guest?.phone ?? '';
        email.text = guest?.email ?? '';
        showForm = true;
        enableSubmit.value = true;
      } else {
        ToastService.error(
          title: 'Error',
          message: result.right.message ?? 'Error desconocido',
        );
      }
      isLoading.value = false;
      update();
      _loaderController.hide();
    } catch (e) {
      debugLog('e: $e');
      isLoading.value = false;
      _loaderController.hide();
    }
  }

  Future<bool> updateMember() async {
    if (guest == null) return false;
    isLoading.value = true;
    _loaderController.show();
    try {
      final Guest updatedGuest = guest!.copyWith(
        firstName: firstName.text,
        lastName: lastName.text,
        dpi: dpi.text,
        nit: nit.text,
        phone: phone.text,
        email: email.text,
      );
      debugLog('updatedGuest: ${updatedGuest.toJson()}');
      final ApiResponse result = await _checkInService.updateGuestInfo(
        updatedGuest,
      );
      if (result.success) {
        ToastService.success(
          title: 'Éxito',
          message: 'Miembro actualizado correctamente',
        );
        isLoading.value = false;
        _loaderController.hide();
        return true;
      }
      ToastService.error(
        title: 'Error',
        message: result.message ?? 'Error desconocido',
      );
      isLoading.value = false;
      _loaderController.hide();
      return false;
    } catch (e) {
      debugLog('e: $e');
      isLoading.value = false;
      _loaderController.hide();
      return false;
    }
  }

  String? validateGuestName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateGuestLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es requerido';
    }
    if (value.length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Teléfono es opcional
    }

    // Regex para números de Guatemala (8 dígitos) con o sin código de área
    final guatemalaRegex = RegExp(
      r'^\+?502?\s*-?\s*([0-9]{4})\s*-?\s*([0-9]{4})$|^([0-9]{4})\s*-?\s*([0-9]{4})$',
    );

    // Regex para números de USA
    final usaRegex = RegExp(
      r'^\+?1?\s*-?\s*([0-9]{3})\s*-?\s*([0-9]{3})\s*-?\s*([0-9]{4})$',
    );

    if (!guatemalaRegex.hasMatch(value) && !usaRegex.hasMatch(value)) {
      return 'Formato inválido. Use: XXXX-XXXX o +502-XXXX-XXXX o +1-XXX-XXX-XXXX';
    }
    return null;
  }

  String? validateDPI(String? value) {
    if (value == null || value.isEmpty) {
      return null; // DPI es opcional
    }

    final dpiRegex = RegExp(r'^\d{13}$');
    if (!dpiRegex.hasMatch(value)) {
      return 'DPI debe tener exactamente 13 dígitos';
    }
    return null;
  }

  String? validateNIT(String? value) {
    if (value == null || value.isEmpty) {
      return null; // NIT es opcional
    }

    // Regex para NIT: 5-12 dígitos, puede tener una K/k al final
    // Permite un guion antes del último dígito o K
    final nitRegex = RegExp(r'^\d{4,11}(-?\d|-?[Kk])$');

    if (!nitRegex.hasMatch(value)) {
      return 'Formato inválido. Ej: XXXXXX-X o XXXXXX-K';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email es opcional
    }

    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Formato de correo inválido';
    }
    return null;
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    dpi.dispose();
    nit.dispose();
    phone.dispose();
    email.dispose();
    checkController.dispose();
    super.dispose();
  }
}
