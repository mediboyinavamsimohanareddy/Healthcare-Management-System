class HealthRecordModel {
  final String id;
  final String userId;
  final String title;
  final String fileUrl;
  final String fileType;
  final DateTime uploadedAt;

  HealthRecordModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      fileUrl: json['fileUrl'],
      fileType: json['fileType'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}
