import 'package:qr_check_in/models/event_model.dart';

class GuestListItem {
  final String code;
  final String familyName;
  final String mainGuestName;
  final String mainGuestDpi;
  final String memberName;
  final String memberDpi;
  final String attendanceStatus;

  final Reservation reservation;
  final ReservationMember member;

  GuestListItem({
    required this.code,
    required this.familyName,
    required this.mainGuestName,
    required this.mainGuestDpi,
    required this.memberName,
    required this.memberDpi,
    required this.attendanceStatus,
    required this.reservation,
    required this.member,
  });

  static List<GuestListItem> fromReservations(List<Reservation> reservations) {
    final List<GuestListItem> items = [];

    for (final reservation in reservations) {
      for (final member in reservation.reservationMembers) {
        items.add(
          GuestListItem(
            code: reservation.id.toString().padLeft(4, '0'),
            familyName: reservation.family.name,
            mainGuestName: reservation.guest.fullName,
            mainGuestDpi: reservation.guest.dpi,
            memberName: member.member.fullName,
            memberDpi: member.member.dpi,
            attendanceStatus: member.attendanceStatusLabel,
            reservation: reservation,
            member: member,
          ),
        );
      }
    }

    return items;
  }
}