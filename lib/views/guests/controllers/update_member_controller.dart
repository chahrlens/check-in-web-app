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
