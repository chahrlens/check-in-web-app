import 'guest_model.dart';
import 'package:qr_check_in/models/has_id_label.dart';

class EventModel {
  final int id;
  final int hostId;
  final String name;
  final String description;
  final int totalSpaces;
  final int totalReservations;
  final int totalFamilies;
  final int guestEntered;
  final DateTime eventDate;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Host host;
  final List<EventTable> eventTables;
  final List<Reservation> reservations;
  final Statistics? statistics;

  EventModel({
    required this.id,
    required this.hostId,
    required this.name,
    required this.description,
    required this.totalSpaces,
    this.totalReservations = 0,
    this.totalFamilies = 0,
    required this.guestEntered,
    required this.eventDate,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.host,
    required this.eventTables,
    required this.reservations,
    this.statistics,
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
    final Map statics = json['statistics']?["summary"] ?? {};
    return EventModel(
      id: json['id'],
      hostId: json['host_id'],
      name: json['name'],
      description: json['description'] ?? '',
      totalSpaces: json['total_spaces'] ?? 0,
      guestEntered: statics['totalCheckedIn'] ?? 0,
      totalReservations: statics['totalReservation'] ?? 0,
      totalFamilies: statics['totalFamilies'] ?? 0,
      eventDate: DateTime.parse(json['event_date']),
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      host: Host.fromJson(json['host']),
      eventTables: tables,
      reservations: reservations,
      statistics: Statistics.fromJson(json['statistics']),
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
      "statistics": statistics,
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
  int get reservationCount => totalReservations;
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
  final int availableCapacity;
  final int reservedCount;
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
    required this.availableCapacity,
    required this.reservedCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventTable.fromJson(Map<String, dynamic> json) {
    return EventTable(
      id: json['id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      tableNumber: json['table_number'] ?? 0,
      capacity: json['capacity'] ?? 0,
      availableCapacity: json['availableCapacity'] ?? 0,
      reservedCount: json['reservedCount'] ?? 0,
      status: json['status'] ?? 0,
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
  final int eventId;
  final int guestId;
  final int familyId;
  final int numCompanions;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Guest guest;
  final Family family;
  final List<ReservationMember> reservationMembers;

  Reservation({
    required this.id,
    required this.eventId,
    required this.guestId,
    required this.familyId,
    required this.numCompanions,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.guest,
    required this.family,
    required this.reservationMembers,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    List<ReservationMember> members = json['reservation_members'] != null
        ? (json['reservation_members'] as List)
              .map((e) => ReservationMember.fromJson(e))
              .toList()
        : [];
    return Reservation(
      id: json['id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      guestId: json['guest_id'] ?? 0,
      familyId: json['family_id'] ?? 0,
      numCompanions: json['num_companions'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      guest: Guest.fromJson(json['guest']),
      family: Family.fromJson(json['family']),
      reservationMembers: members,
    );
  }
}

class EventReservation {
  final int eventId;
  final Family family;
  List<Guest> details;

  EventReservation({
    required this.eventId,
    required this.family,
    this.details = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "eventId": eventId,
      ...family.toJson(),
      "guests": details.map((e) => e.toJson()).toList(),
    };
  }

  factory EventReservation.fromJson(Map<String, dynamic> json) {
    // Crear la familia
    Family family;

    if (json['family'] != null) {
      final familyJson = json['family'] as Map<String, dynamic>;
      final familyName = familyJson['familyName'] ?? 'Sin Nombre';

      if (familyJson['id'] != null) {
        // Si tiene ID, crear una familia con ese ID
        family = Family(
          id: familyJson['id'],
          name: familyName,
          status: 1,
          createdAt: DateTime.now(),
          familyTables: [],
        );
      } else {
        // Si no tiene ID, crear una familia nueva
        family = Family.instance(name: familyName);
      }

      // Asignar mesas a la familia si existen
      if (json['tableIds'] != null && json['tableIds'] is List) {
        final tableIds = List<int>.from(json['tableIds']);
        // Crear FamilyTables para cada ID de mesa
        family = Family(
          id: family.id,
          name: family.name,
          status: family.status,
          createdAt: family.createdAt,
          updatedAt: family.updatedAt,
          familyTables: tableIds
              .map(
                (tableId) => FamilyTable(
                  id: 0,
                  familyId: family.id,
                  tableId: tableId,
                  status: 1,
                  createdAt: DateTime.now(),
                  updatedAt: null,
                ),
              )
              .toList(),
        );
      }
    } else {
      // Si no hay información de familia, crear una por defecto
      family = Family.instance();
    }

    // Crear lista de invitados
    List<Guest> guests = [];
    if (json['guests'] != null && json['guests'] is List) {
      guests = (json['guests'] as List)
          .map((guestJson) => Guest.fromJson(guestJson))
          .toList();
    }

    return EventReservation(
      eventId: json['eventId'],
      family: family,
      details: guests,
    );
  }

  factory EventReservation.instance({
    required int eventId,
    required Family family,
    List<Guest> details = const [],
  }) {
    return EventReservation(eventId: eventId, family: family, details: details);
  }

  EventReservation copyWith({
    int? eventId,
    Family? family,
    List<Guest>? details,
  }) {
    return EventReservation(
      eventId: eventId ?? this.eventId,
      family: family ?? this.family,
      details: details ?? this.details,
    );
  }
}

class Family implements HasIdLabel {
  final int id;
  final String name;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<FamilyTable> familyTables;

  Family({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.familyTables,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    List<FamilyTable> tables = json['family_tables'] != null
        ? (json['family_tables'] as List)
              .map((e) => FamilyTable.fromJson(e))
              .toList()
        : [];
    return Family(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      familyTables: tables,
    );
  }

  factory Family.instance({
    String name = "Sin Nombre",
    List<FamilyTable> familyTables = const [],
  }) {
    return Family(
      id: 0,
      name: name,
      status: 1,
      createdAt: DateTime.now(),
      familyTables: familyTables,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "family": {"id": id == 0 ? null : id, "familyName": name},
      "tableIds": familyTables.map((e) => e.tableId).toList(),
    };
  }

  String get familyTableList =>
      familyTables.map((e) => e.eventTable?.name ?? '').join(', ');

  @override
  String get identifier => id.toString();
  @override
  String get identifierLabel => name;
}

class FamilyTable {
  final int id;
  final int familyId;
  final int tableId;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final EventTable? eventTable;

  FamilyTable({
    required this.id,
    required this.familyId,
    required this.tableId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.eventTable,
  });

  factory FamilyTable.fromJson(Map<String, dynamic> json) {
    final data = json['family_table'] ?? json;
    return FamilyTable(
      id: data['id'] ?? 0,
      familyId: data['family_id'] ?? 0,
      tableId: data['table_id'] ?? 0,
      status: data['status'] ?? 0,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'])
          : null,
      eventTable: EventTable.fromJson(data['event_table']),
    );
  }

  factory FamilyTable.fromEventTable(EventTable table) {
    return FamilyTable(
      id: 0,
      familyId: 0,
      tableId: table.id,
      status: 1,
      createdAt: DateTime.now(),
      updatedAt: null,
      eventTable: table,
    );
  }
}

class ReservationMember {
  final int id;
  final int reservationId;
  final int tableId;
  final int personId;
  final String uuidCode;
  final String attendanceStatus;
  final int status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Guest member;

  ReservationMember({
    required this.id,
    required this.reservationId,
    required this.tableId,
    required this.personId,
    required this.uuidCode,
    required this.status,
    required this.createdAt,
    this.attendanceStatus = '',
    this.updatedAt,
    required this.member,
  });

  factory ReservationMember.fromJson(Map<String, dynamic> json) {
    return ReservationMember(
      id: json['id'] ?? 0,
      reservationId: json['reservation_id'] ?? 0,
      tableId: json['table_id'] ?? 0,
      personId: json['person_id'] ?? 0,
      uuidCode: json['uuid_code'] ?? '',
      attendanceStatus: json['attendance_status'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      member: Guest.fromJson(json['member']),
    );
  }

  String get attendanceStatusLabel {
    switch (attendanceStatus) {
      case 'PENDING':
        return 'Pendiente';
      case 'USED':
        return 'Confirmado';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }
}

class Statistics {
  final Summary summary;
  final Details details;

  Statistics({required this.summary, required this.details});

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      summary: Summary.fromJson(json['summary']),
      details: Details.fromJson(json['details'] ?? {}),
    );
  }
}

class Summary {
  final int totalGuests;
  final int totalCheckedIn;
  final int totalFamilies;
  final int totalTables;
  final int totalCapacity;
  final int availableSpaces;
  final String occupancyRate;

  Summary({
    required this.totalGuests,
    required this.totalCheckedIn,
    required this.totalFamilies,
    required this.totalTables,
    required this.totalCapacity,
    required this.availableSpaces,
    required this.occupancyRate,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalGuests: json['totalGuests'] ?? 0,
      totalCheckedIn: json['totalCheckedIn'] ?? 0,
      totalFamilies: json['totalFamilies'] ?? 0,
      totalTables: json['totalTables'] ?? 0,
      totalCapacity: json['totalCapacity'] ?? 0,
      availableSpaces: json['availableSpaces'] ?? 0,
      occupancyRate: json['occupancyRate'] ?? '',
    );
  }
}

class Details {
  final List<FamilyDetails> families;
  final List<TableDetails> tables;

  Details({required this.families, required this.tables});

  factory Details.fromJson(Map<String, dynamic> json) {
    List<FamilyDetails> families = json['families'] != null
        ? (json['families'] as List)
              .map((e) => FamilyDetails.fromJson(e))
              .toList()
        : [];
    List<TableDetails> tables = json['tables'] != null
        ? (json['tables'] as List).map((e) => TableDetails.fromJson(e)).toList()
        : [];
    return Details(families: families, tables: tables);
  }
}

class FamilyDetails {
  final int id;
  final String name;
  final int membersCount;
  final int checkedInCount;
  final List<int> assignedTables;

  FamilyDetails({
    required this.id,
    required this.name,
    required this.membersCount,
    required this.checkedInCount,
    required this.assignedTables,
  });

  factory FamilyDetails.fromJson(Map<String, dynamic> json) {
    return FamilyDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      membersCount: json['membersCount'] ?? 0,
      checkedInCount: json['checkedInCount'] ?? 0,
      assignedTables: List<int>.from(json['assignedTables'] ?? []),
    );
  }
}

class TableDetails {
  final int id;
  final int capacity;
  final int assigned;

  TableDetails({
    required this.id,
    required this.capacity,
    required this.assigned,
  });

  factory TableDetails.fromJson(Map<String, dynamic> json) {
    return TableDetails(
      id: json['id'] ?? 0,
      capacity: json['capacity'] ?? 0,
      assigned: json['assigned'] ?? 0,
    );
  }
}
