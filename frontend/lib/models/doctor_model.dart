class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String specialty;
  final String? experience;
  final String? phone;
  final String? bio;
  final double? rating;
  final int? reviewsCount;
  final int? price;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.specialty,
    this.experience,
    this.phone,
    this.bio,
    this.rating,
    this.reviewsCount,
    this.price,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      specialty: json['specialty'],
      experience: json['experience'],
      phone: json['phone'],
      bio: json['bio'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewsCount: json['reviewsCount'] != null ? (json['reviewsCount'] as num).toInt() : null,
      price: json['price'] != null ? (json['price'] as num).toInt() : null,
    );
  }
}
