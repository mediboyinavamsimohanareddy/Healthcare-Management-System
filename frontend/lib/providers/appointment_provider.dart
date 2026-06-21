import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/appointment_model.dart';
import '../utils/constants.dart';

class AppointmentProvider with ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> get appointments => _appointments;

  Future<void> fetchUserAppointments(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/appointments/user'),
      headers: {'x-auth-token': token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      _appointments = data.map((json) => AppointmentModel.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<bool> bookAppointment(String token, String doctorId, String doctorName, String date, String time) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/appointments/book'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: json.encode({
        'doctorId': doctorId,
        'doctorName': doctorName,
        'date': date,
        'time': time,
      }),
    );

    if (response.statusCode == 200) {
      fetchUserAppointments(token);
      return true;
    }
    return false;
  }

  Future<void> cancelAppointment(String token, String appointmentId) async {
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/appointments/cancel/$appointmentId'),
      headers: {'x-auth-token': token},
    );

    if (response.statusCode == 200) {
      fetchUserAppointments(token);
    }
  }
}
