import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Expert {
  final String id;
  final String firstName;
  final String lastName;
  String phone;
  final String email;
  final String password;
  final String role;
  Expert({
    this.id = "",
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  factory Expert.fromMap(Map<String, dynamic> map) {
    return Expert(
      id: map['_id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phone: map['phone'] as String,
      email: map['email'] ?? "",
      password: map['password'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expert.fromJson(String source) =>
      Expert.fromMap(json.decode(source) as Map<String, dynamic>);

  Expert copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? password,
    String? role,
  }) {
    return Expert(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
