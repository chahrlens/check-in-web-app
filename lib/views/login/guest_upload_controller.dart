import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_check_in/models/either.dart';
import 'package:qr_check_in/models/guest_model.dart';
import 'package:qr_check_in/models/api_response.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/shared/utils/loggers.dart';
import 'package:qr_check_in/services/event_service.dart';
import 'package:qr_check_in/controllers/loader_controller.dart';

class GuestUploadController extends GetxController {
  final EventService _eventService = EventService();
  final TextEditingController eventName = TextEditingController();
  final TextEditingController hostName = TextEditingController();
  final TextEditingController totalTables = TextEditingController();
  final TextEditingController totalGuests = TextEditingController();
  final TextEditingController totalCapacity = TextEditingController();
  final TextEditingController availableSpaces = TextEditingController();

  final LoaderController _loaderController = Get.find<LoaderController>();
  EventModel? selectedEvent;

  List<EventReservation> reservations = [];
  List<EventReservation> reservationsFiltered = [];

  final RxList<Guest> guestList = <Guest>[].obs;
  final Rx<XFile?> selectedFile = Rx<XFile?>(null);
  final RxString fileName = ''.obs;

  void setEventData(dynamic args) {
    if (args != null && args['data'] != null && args['data'] is EventModel) {
      selectedEvent = args['data'] as EventModel;
      eventName.text = selectedEvent!.name;
      hostName.text = selectedEvent!.host.fullName;
      totalTables.text =
          selectedEvent?.statistics?.summary.totalTables.toString() ?? '';
      totalGuests.text =
          selectedEvent?.statistics?.summary.totalGuests.toString() ?? '';
      totalCapacity.text =
          selectedEvent?.statistics?.summary.totalCapacity.toString() ?? '';
      availableSpaces.text =
          selectedEvent?.statistics?.summary.availableSpaces.toString() ?? '';
      debugLog('Evento seleccionado para carga masiva: ${selectedEvent!.name}');
    }
  }

  Future<String?> handleUpload() async {
    try {
      _loaderController.show();

      // Usar ImagePicker para seleccionar archivo
      final picker = ImagePicker();
      // No podemos filtrar directamente por tipo de archivo Excel en ImagePicker
      // Usaremos el método genérico y validaremos después
      final XFile? pickedFile = await picker.pickMedia();

      if (pickedFile == null) {
        _loaderController.hide();
        return 'No se seleccionó ningún archivo';
      }

      // Verificar que sea un archivo Excel
      String extension = pickedFile.name.split('.').last.toLowerCase();
      if (extension != 'xlsx' && extension != 'xls') {
        _loaderController.hide();
        return 'El archivo debe ser de formato Excel (.xlsx o .xls)';
      }

      selectedFile.value = pickedFile;
      fileName.value = pickedFile.name;

      // Obtener el ID del evento actual (en un caso real)
      // final eventId = _sessionController.getCurrentEventId(); // Suponiendo que existe este método

      // Para pruebas, usaremos un ID fijo
      const int eventId = 1;

      // Leer el archivo como bytes
      Uint8List fileBytes;
      if (kIsWeb) {
        // En web, leer directamente
        fileBytes = await pickedFile.readAsBytes();
      } else {
        // En plataformas nativas, leer como archivo
        final File file = File(pickedFile.path);
        fileBytes = await file.readAsBytes();
      }

      // Enviar el archivo al servidor
      final Either<List<EventReservation>?, ApiResponse> response =
          await _eventService.uploadGuestFile(
            eventId: eventId,
            file: fileBytes,
            fileName: pickedFile.name,
          );

      if (!response.right.success) {
        _loaderController.hide();
        return 'Error al cargar el archivo: ${response.right.message}';
      }
      // Si la carga fue exitosa, podemos procesar la respuesta
      reservations.assignAll(response.left ?? []);
      reservationsFiltered.assignAll(List.from(reservations));

      _loaderController.hide();
      update();
      return null;
    } catch (e) {
      _loaderController.hide();
      debugLog('Error en la carga de archivo: $e');
      return 'Error al cargar el archivo: ${e.toString()}';
    }
  }

  Future<String?> handleSave() async {
    try {
      _loaderController.show();

      if (selectedFile.value == null) {
        _loaderController.hide();
        return 'Primero debes seleccionar un archivo';
      }

      // Mostrar que estamos procesando
      await Future.delayed(const Duration(seconds: 1));

      // En un caso real, aquí procesaríamos los datos recibidos del archivo
      // Pero como esto es una simulación y ya enviamos el archivo en handleUpload,
      // simplemente mostraremos un mensaje de éxito

      // Limpiar después de guardar
      selectedFile.value = null;
      fileName.value = '';

      _loaderController.hide();
      return null;
    } catch (e) {
      _loaderController.hide();
      debugLog('Error al guardar: $e');
      return 'Error al guardar los datos: ${e.toString()}';
    }
  }
}
