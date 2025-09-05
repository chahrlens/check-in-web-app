class Guest {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String dpi;
  final String nit;
  final String phone;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Guest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.dpi,
    required this.nit,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      dpi: json['dpi'] ?? '',
      nit: json['nit'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  factory Guest.instance({
    String firstName = "anonymous",
    String lastName = "",
    String role = "guest",
    String dpi = "",
    String nit = "",
    String phone = "",
    String email = "",
  }) {
    return Guest(
      id: 0,
      firstName: firstName,
      lastName: lastName,
      role: role,
      dpi: dpi,
      nit: nit,
      phone: phone,
      email: email,
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJson() {
    if (firstName == "anonymous") {
      return {"isAnonymous": true};
    }
    return {
      "id": id == 0 ? null : id,
      "firstName": firstName,
      "lastName": lastName,
      "role": role,
      "dpi": dpi,
      "nit": nit,
      "phone": phone,
      "email": email,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Guest &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          dpi == other.dpi &&
          nit == other.nit &&
          phone == other.phone;

  @override
  int get hashCode =>
      id.hashCode ^
      fullName.hashCode ^
      dpi.hashCode ^
      nit.hashCode ^
      phone.hashCode;
}
