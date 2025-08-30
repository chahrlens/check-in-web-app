import 'package:qr_check_in/models/has_id_label.dart';
import 'guest_model.dart';

class EventModel {
  final int id;
  final int hostId;
  final String name;
  final String description;
  final int totalSpaces;
  final int guestEntered;
  final DateTime eventDate;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Host host;
  final List<EventTable> eventTables;
  final List<Reservation> reservations;

  EventModel({
    required this.id,
    required this.hostId,
    required this.name,
    required this.description,
    required this.totalSpaces,
    required this.guestEntered,
    required this.eventDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.host,
    required this.eventTables,
    required this.reservations,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<EventTable> tables = json['event_tables'] != null
        ? (json['event_tables'] as List)
              .map((e) => EventTable.fromJson(e))
              .toList()
        : [];
    List<Reservation> reservations = json['reservations'] != null
        ? (json['reservations'] as List)
              .map((e) => Reservation.fromJson(e))
              .toList()
        : [];
    return EventModel(
      id: json['id'],
      hostId: json['host_id'],
      name: json['name'],
      description: json['description'] ?? '',
      totalSpaces: json['total_spaces'] ?? 0,
      guestEntered: json['companionsEntered'] ?? 0,
      eventDate: DateTime.parse(json['event_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      host: Host.fromJson(json['host']),
      eventTables: tables,
      reservations: reservations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "hostData": host.toJson(),
      "eventData": {
        "name": name,
        "description": description,
        "totalSpaces": totalSpaces,
        "eventDate": eventDate.toIso8601String(),
      },
      "tablesData": eventTables.map((table) => table.toJson()).toList(),
    };
  }

  Map<String, dynamic> tableUpdateJson() {
    return {
      "eventId": id,
      "tablesData": eventTables.map((table) => table.toJson()).toList(),
    };
  }

  Map<String, dynamic> toPutJson() {
    return {
      "eventId": id,
      "hostId": host.id,
      "hostData": host.toJson(),
      "eventData": {
        "name": name,
        "description": description,
        "totalSpaces": totalSpaces,
        "eventDate": eventDate.toIso8601String(),
      },
      "tablesData": eventTables
          .where((e) => e.id == 0)
          .map((e) => e.toJson())
          .toList(),
    };
  }

  int get tableCount => eventTables.length;
  int get reservationCount =>
      reservations.fold(0, (sum, r) => sum + r.numCompanions);
  int get availableUnAssigned => totalSpaces - reservationCount;
  int get availableCount => reservationCount - guestEntered;
}

class Host {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String dpi;
  final String nit;
  final String phone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Host({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.dpi,
    required this.nit,
    required this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      dpi: json['dpi'] ?? '',
      nit: json['nit'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "role": role,
      "dpi": dpi,
      "nit": nit,
      "phone": phone,
    };
  }

  String get fullName => '$firstName $lastName';
}

class EventTable implements HasIdLabel {
  final int id;
  final int eventId;
  final String name;
  final String description;
  final int tableNumber;
  final int capacity;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  EventTable({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventTable.fromJson(Map<String, dynamic> json) {
    return EventTable(
      id: json['id'],
      eventId: json['event_id'],
      name: json['name'],
      description: json['description'],
      tableNumber: json['table_number'],
      capacity: json['capacity'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTable &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name.hashCode == name.hashCode &&
          tableNumber == other.tableNumber;
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tableNumber.hashCode;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "tableNumber": tableNumber,
      "capacity": capacity,
    };
  }

  @override
  String get identifier => id.toString();

  @override
  String get identifierLabel => "$name '$description'";
}

class Reservation {
  final int id;
  final String uuidCode;
  final int eventId;
  final int tableId;
  final int guestId;
  final int numCompanions;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Guest guest;
  final EventTable table;

  Reservation({
    required this.id,
    required this.uuidCode,
    required this.eventId,
    required this.tableId,
    required this.guestId,
    required this.numCompanions,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.guest,
    required this.table,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      uuidCode: json['uuid_code'],
      eventId: json['event_id'],
      tableId: json['table_id'],
      guestId: json['guest_id'],
      numCompanions: json['num_companions'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      guest: Guest.fromJson(json['guest']), // Ensure Guest is imported
      table: EventTable.fromJson(json['table']),
    );
  }
}

class EventReservation {
  final int eventId;
  final List<ReservationDetails> details;

  EventReservation({required this.eventId, required this.details});

  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      "reservations": details.map((e) => e.toJson()).toList(),
    };
  }
}

class ReservationDetails {
  final String guestName;
  final String guestLastName;
  final String phone;
  final String dpi;
  final String nit;
  final int tableId;
  final String table;
  final int totalOccupants;

  ReservationDetails({
    required this.guestName,
    required this.guestLastName,
    required this.phone,
    required this.dpi,
    required this.nit,
    required this.tableId,
    required this.table,
    required this.totalOccupants,
  });

  Map<String, dynamic> toJson() {
    return {
      "guestName": guestName,
      "guestLastName": guestLastName,
      "phone": phone,
      "dpi": dpi,
      "nit": nit,
      "tableId": tableId,
      "totalOccupants": totalOccupants,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationDetails &&
          runtimeType == other.runtimeType &&
          guestName == other.guestName &&
          guestLastName == other.guestLastName &&
          phone == other.phone &&
          dpi == other.dpi &&
          nit == other.nit &&
          tableId == other.tableId &&
          totalOccupants == other.totalOccupants;

  @override
  int get hashCode =>
      guestName.hashCode ^
      guestLastName.hashCode ^
      phone.hashCode ^
      dpi.hashCode ^
      nit.hashCode ^
      tableId.hashCode ^
      totalOccupants.hashCode;
}
