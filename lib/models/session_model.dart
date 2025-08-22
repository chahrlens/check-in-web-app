
import 'package:qr_check_in/models/simple_entity_model.dart';

class SessionResponse {
  final bool success;
  final UserData data;

  SessionResponse({
    required this.success,
    required this.data,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      success: json['success'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String username;
  final String token;
  final RoleModel? role;
  final PersonModel? person;
  final SimpleEntity? group;

  UserData({
    required this.id,
    required this.username,
    required this.token,
    this.role,
    this.person,
    this.group,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
      person:
          json['person'] != null ? PersonModel.fromJson(json['person']) : null,
      group: json['group'] != null
          ? SimpleEntity.fromJson(json['group'])
          : SimpleEntity(id: "", name: ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'token': token,
    };
  }
}

class RoleModel {
  final int id;
  final String name;

  RoleModel({
    required this.id,
    required this.name,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class PersonModel {
  final int id;
  final String firstName;
  final String? lastName;
  final String? employeeId; // Optional field

  PersonModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.employeeId,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json?['lastName'] ?? "",
      employeeId: json['employeeId'] != null
          ? json['employeeId'].toString()
          : null, // Optional field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
