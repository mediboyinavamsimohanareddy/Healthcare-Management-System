import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';
import '../utils/constants.dart';

class DoctorProvider with ChangeNotifier {
  List<DoctorModel> _doctors = [];
  List<DoctorModel> get doctors => _doctors;

  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/doctors'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      _doctors = data.map((json) => DoctorModel.fromJson(json)).toList();
      notifyListeners();
    }
  }

  List<DoctorModel> searchDoctors(String query) {
    return _doctors.where((doc) => 
      doc.name.toLowerCase().contains(query.toLowerCase()) || 
      doc.specialty.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
