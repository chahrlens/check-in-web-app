class Guest {
	final int id;
	final String firstName;
	final String lastName;
	final String role;
	final String dpi;
	final String nit;
	final String phone;
	final DateTime createdAt;
	final DateTime? updatedAt;

	Guest({
		required this.id,
		required this.firstName,
		required this.lastName,
		required this.role,
		required this.dpi,
		required this.nit,
		required this.phone,
		required this.createdAt,
		required this.updatedAt,
	});

	factory Guest.fromJson(Map<String, dynamic> json) {
		return Guest(
			id: json['id'],
			firstName: json['first_name'],
			lastName: json['last_name'],
			role: json['role'],
			dpi: json['dpi'],
			nit: json['nit'],
			phone: json['phone'],
			createdAt: DateTime.parse(json['created_at']),
			updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
		);
	}
}
