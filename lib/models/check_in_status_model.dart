import 'package:qr_check_in/models/guest_model.dart';

class CheckInStatusData {
  final Reservation reservation;
  final Guest guest;
  final Companions companions;
  final int totalSpacesRemaining;
  final TableInfo table;
  final Event event;
  final List<CheckIn> checkIns;

  CheckInStatusData({
    required this.reservation,
    required this.guest,
    required this.companions,
    required this.totalSpacesRemaining,
    required this.table,
    required this.event,
    required this.checkIns,
  });

  factory CheckInStatusData.fromJson(Map<String, dynamic> json) {
    return CheckInStatusData(
      reservation: Reservation.fromJson(json['reservation']),
      guest: Guest.fromJson(json['guest']),
      companions: Companions.fromJson(json['companions']),
      totalSpacesRemaining: json['totalSpacesRemaining'],
      table: TableInfo.fromJson(json['table']),
      event: Event.fromJson(json['event']),
      checkIns: (json['checkIns'] as List)
          .map((e) => CheckIn.fromJson(e))
          .toList(),
    );
  }
}

class Reservation {
  final int id;
  final String uuid;
  final int totalReserved;
  final int status;

  Reservation({
    required this.id,
    required this.uuid,
    required this.totalReserved,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      uuid: json['uuid'],
      totalReserved: json['totalReserved'],
      status: json['status'],
    );
  }
}

class Companions {
  final int total;
  final int entered;
  final int remaining;

  Companions({
    required this.total,
    required this.entered,
    required this.remaining,
  });

  factory Companions.fromJson(Map<String, dynamic> json) {
    return Companions(
      total: json['total'],
      entered: json['entered'],
      remaining: json['remaining'],
    );
  }
}

class TableInfo {
  final int id;
  final String name;
  final int tableNumber;

  TableInfo({required this.id, required this.name, required this.tableNumber});

  factory TableInfo.fromJson(Map<String, dynamic> json) {
    return TableInfo(
      id: json['id'],
      name: json['name'],
      tableNumber: json['tableNumber'],
    );
  }
}

class Event {
  final int id;
  final String name;
  final DateTime date;

  Event({required this.id, required this.name, required this.date});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }
}

class CheckIn {
  final int id;
  final bool guestEntered;
  final int numCompanionsEntered;
  final DateTime createdAt;

  CheckIn({
    required this.id,
    required this.guestEntered,
    required this.numCompanionsEntered,
    required this.createdAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'],
      guestEntered: json['guestEntered'],
      numCompanionsEntered: json['numCompanionsEntered'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
