class CheckInModel {
  final CheckReservation reservation;
  final CheckGuest guest;
  final Participants companions;
  final int totalSpacesRemaining;
  final TableInfo table;
  final EventInfo event;
  final List<CheckInEntry> checkIns;

  CheckInModel({
    required this.reservation,
    required this.guest,
    required this.companions,
    required this.totalSpacesRemaining,
    required this.table,
    required this.event,
    required this.checkIns,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      reservation: CheckReservation.fromJson(json['reservation']),
      guest: CheckGuest.fromJson(json['guest']),
      companions: Participants.fromJson(json['companions']),
      totalSpacesRemaining: json['totalSpacesRemaining'],
      table: TableInfo.fromJson(json['table']),
      event: EventInfo.fromJson(json['event']),
      checkIns: (json['checkIns'] as List)
          .map((e) => CheckInEntry.fromJson(e))
          .toList(),
    );
  }
}

class CheckReservation {
  final int id;
  final String uuid;
  final int totalReserved;
  final int status;

  CheckReservation({
    required this.id,
    required this.uuid,
    required this.totalReserved,
    required this.status,
  });

  factory CheckReservation.fromJson(Map<String, dynamic> json) {
    return CheckReservation(
      id: json['id'],
      uuid: json['uuid'],
      totalReserved: json['totalReserved'],
      status: json['status'],
    );
  }
}

class CheckGuest {
  final int id;
  final String name;
  final String dpi;
  final String phone;
  final bool hasEntered;

  CheckGuest({
    required this.id,
    required this.name,
    required this.dpi,
    required this.phone,
    required this.hasEntered,
  });

  factory CheckGuest.fromJson(Map<String, dynamic> json) {
    return CheckGuest(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      dpi: json['dpi'] ?? '',
      phone: json['phone'] ?? '',
      hasEntered: json['hasEntered'] ?? false,
    );
  }
}

class Participants {
  final int total;
  final int entered;
  final int remaining;

  Participants({
    required this.total,
    required this.entered,
    required this.remaining,
  });

  factory Participants.fromJson(Map<String, dynamic> json) {
    return Participants(
      total: json['total'] ?? 0,
      entered: json['entered'] ?? 0,
      remaining: json['remaining'] ?? 0,
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tableNumber: json['tableNumber'] ?? 0,
    );
  }
}

class EventInfo {
  final int id;
  final String name;
  final DateTime date;

  EventInfo({required this.id, required this.name, required this.date});

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    return EventInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
    );
  }
}

class CheckInEntry {
  final int id;
  final bool guestEntered;
  final int numCompanionsEntered;
  final DateTime createdAt;

  CheckInEntry({
    required this.id,
    required this.guestEntered,
    required this.numCompanionsEntered,
    required this.createdAt,
  });

  factory CheckInEntry.fromJson(Map<String, dynamic> json) {
    return CheckInEntry(
      id: json['id'] ?? 0,
      guestEntered: json['guestEntered'] ?? false,
      numCompanionsEntered: json['numCompanionsEntered'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
    );
  }
}
