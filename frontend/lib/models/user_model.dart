class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int? age;
  final String? gender;
  final String? bloodGroup;
  final String? emergencyContact;
  final String? medicalHistory;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.age,
    this.gender,
    this.bloodGroup,
    this.emergencyContact,
    this.medicalHistory,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      age: json['age'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      emergencyContact: json['emergencyContact'],
      medicalHistory: json['medicalHistory'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
    };
  }
}
