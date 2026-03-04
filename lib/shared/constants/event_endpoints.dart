class EventEndpoints {
  static const String _eventBase = '/event/events';
  static const String _checkInBase = '/check-in';

  // Event endpoints
  static String get events => _eventBase;
  static String get eventTables => '$_eventBase/tables';
  static String get eventReservations => '$_eventBase/reservations';
  static String get reservationsMembersBulk => '$_eventBase/reservations-members-bulk';
  static String get families => '$_eventBase/families';
  static String get reservationsMembers => '$_eventBase/reservations-members';
  static String guestUpload(int eventId) => '$_eventBase/guest-upload/$eventId';
  static String getEventTables({required int eventId, int filterAvailable = 1}) => '$_eventBase/tables';
  static String deleteEvent({required int eventId}) => '$_eventBase/';

  // Check-in endpoints
  static String checkInAvailability(String uuid) => '$_checkInBase/availability/$uuid';
  static String get checkIn => '$_checkInBase/check-in';
  static String person(String uuid) => '$_checkInBase/person/$uuid';
  static String updatePerson(int id) => '$_checkInBase/person/$id';
}