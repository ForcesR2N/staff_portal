import 'login_response_model.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String? image;
  final String? phone;
  final String? company;
  final String? title;
  final String? department;
  final int? age;
  final String? address;
  final DateTime? birthDate;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    this.image,
    this.phone,
    this.company,
    this.title,
    this.department,
    this.age,
    this.address,
    this.birthDate,
  });

  String get fullName => '$firstName $lastName';
  String? get avatar => image;
  String get jobTitle => title ?? 'Staff';
  String get jobDepartment => department ?? company ?? 'General';

  // Factory untuk convert dari LoginResponseModel
  factory UserModel.fromLoginResponse(LoginResponseModel loginResponse) {
    return UserModel(
      id: loginResponse.id,
      username: loginResponse.username,
      email: loginResponse.email,
      firstName: loginResponse.firstName,
      lastName: loginResponse.lastName,
      gender: loginResponse.gender,
      image: loginResponse.image,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested company object
    String? companyName;
    String? departmentName;
    String? titleName;
    
    if (json['company'] is Map) {
      final companyData = json['company'];
      companyName = companyData['name'];
      departmentName = companyData['department'];
      titleName = companyData['title']; 
    } else if (json['company'] is String) {
      companyName = json['company'];
    }

    // Handle nested address object
    String? addressString;
    if (json['address'] is Map) {
      final address = json['address'];
      final city = address['city'] ?? '';
      final state = address['state'] ?? '';
      addressString = '$city, $state'.trim();
      if (addressString == ',') addressString = null;
    } else if (json['address'] is String) {
      addressString = json['address'];
    }

    // Parse birthDate from birthDate field
    DateTime? parsedBirthDate;
    if (json['birthDate'] != null) {
      try {
        final birthDateStr = json['birthDate'].toString();
        // Handle simple format like "1996-5-30" 
        final parts = birthDateStr.split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          parsedBirthDate = DateTime(year, month, day);
        } else {
          // Fallback to standard DateTime.parse
          parsedBirthDate = DateTime.parse(birthDateStr);
        }
      } catch (e) {
        parsedBirthDate = null;
      }
    }

    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'],
      phone: json['phone'],
      company: companyName,
      title: titleName,
      department: departmentName,
      age: json['age'],
      address: addressString,
      birthDate: parsedBirthDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'phone': phone,
      'company': company,
      'title': title,
      'department': department,
      'age': age,
      'address': address,
      'birthDate': birthDate != null ? '${birthDate!.year}-${birthDate!.month}-${birthDate!.day}' : null,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? phone,
    String? company,
    String? title,
    String? department,
    int? age,
    String? address,
    DateTime? birthDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      title: title ?? this.title,
      department: department ?? this.department,
      age: age ?? this.age,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, fullName: $fullName)';
  }
}