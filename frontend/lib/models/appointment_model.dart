class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final String userName;
  final String doctorName;
  final String date;
  final String time;
  final String status;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.userName,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      userName: json['userName'],
      doctorName: json['doctorName'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}
