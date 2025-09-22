import 'package:get/get.dart';
import 'package:qr_check_in/models/event_model.dart';
import 'package:qr_check_in/views/guests/models/guest_list_item.dart';

class ListGuestController extends GetxController {
  EventModel? selectedEvent;

  List<Reservation> reservations = <Reservation>[];

  List<GuestListItem> guestItems = <GuestListItem>[];

  String normalizeText(String text) {
    final Map<String, String> accentMap = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'à': 'a',
      'è': 'e',
      'ì': 'i',
      'ò': 'o',
      'ù': 'u',
      'ä': 'a',
      'ë': 'e',
      'ï': 'i',
      'ö': 'o',
      'ü': 'u',
      'â': 'a',
      'ê': 'e',
      'î': 'i',
      'ô': 'o',
      'û': 'u',
      'ã': 'a',
      'ñ': 'n',
      'õ': 'o',
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'À': 'A',
      'È': 'E',
      'Ì': 'I',
      'Ò': 'O',
      'Ù': 'U',
      'Ä': 'A',
      'Ë': 'E',
      'Ï': 'I',
      'Ö': 'O',
      'Ü': 'U',
      'Â': 'A',
      'Ê': 'E',
      'Î': 'I',
      'Ô': 'O',
      'Û': 'U',
      'Ã': 'A',
      'Ñ': 'N',
      'Õ': 'O',
    };

    String normalized = text;
    accentMap.forEach((key, value) {
      normalized = normalized.replaceAll(key, value);
    });

    return normalized;
  }

  void initialize(dynamic args) {
    if (args != null && args['data'] != null && args['data'] is EventModel) {
      selectedEvent = args['data'] as EventModel;

      reservations.assignAll(selectedEvent!.reservations);

      guestItems.assignAll(GuestListItem.fromReservations(reservations));
    }
  }

  List<GuestListItem> filterGuestItems(String query) {
    if (query.isEmpty) {
      return selectedEvent != null
          ? GuestListItem.fromReservations(selectedEvent!.reservations)
          : [];
    }

    final normalizedQuery = normalizeText(query.toLowerCase());

    String searchQuery = optimizeStatusQuery(normalizedQuery);

    return guestItems.where((item) {
      final normalizedFamilyName = normalizeText(item.familyName.toLowerCase());
      final normalizedMainGuestName = normalizeText(item.mainGuestName.toLowerCase());
      final normalizedMainGuestDpi = item.mainGuestDpi.toLowerCase();
      final normalizedMemberName = normalizeText(item.memberName.toLowerCase());
      final normalizedMemberDpi = item.memberDpi.toLowerCase();
      final normalizedStatus = normalizeText(item.attendanceStatus.toLowerCase());

      return normalizedFamilyName.contains(searchQuery) ||
             normalizedMainGuestName.contains(searchQuery) ||
             normalizedMainGuestDpi.contains(searchQuery) ||
             normalizedMemberName.contains(searchQuery) ||
             normalizedMemberDpi.contains(searchQuery) ||
             normalizedStatus.contains(searchQuery) ||
             item.code.contains(searchQuery);
    }).toList();
  }

  String optimizeStatusQuery(String query) {
    if (query == 'confirmado' || query == 'confirmados') {
      return 'confirmado';
    } else if (query == 'pendiente' || query == 'pendientes') {
      return 'pendiente';
    } else if (query == 'cancelado' || query == 'cancelados') {
      return 'cancelado';
    }
    return query;
  }

  void filterData(String query) {
    if (selectedEvent != null) {
      if (query.isEmpty) {
        guestItems.assignAll(GuestListItem.fromReservations(selectedEvent!.reservations));
        reservations.assignAll(selectedEvent!.reservations);
      } else {
        final filteredItems = filterGuestItems(query);
        guestItems.assignAll(filteredItems);

        if (filteredItems.isNotEmpty) {
          final uniqueReservationIds = filteredItems
              .map((item) => item.reservation.id)
              .toSet();

          final filteredReservations = selectedEvent!.reservations
              .where((r) => uniqueReservationIds.contains(r.id))
              .toList();

          reservations.assignAll(filteredReservations);
        } else {
          reservations.clear();
        }
      }
    }
    update();
  }
}
