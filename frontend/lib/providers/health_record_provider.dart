import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/health_record_model.dart';
import '../utils/constants.dart';

class HealthRecordProvider with ChangeNotifier {
  List<HealthRecordModel> _records = [];
  List<HealthRecordModel> get records => _records;

  Future<void> fetchUserRecords(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/records/user'),
      headers: {'x-auth-token': token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      _records = data.map((json) => HealthRecordModel.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<bool> uploadRecord(String token, String title, String fileType, File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/records/upload'),
    );
    request.headers['x-auth-token'] = token;
    request.fields['title'] = title;
    request.fields['fileType'] = fileType;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      fetchUserRecords(token);
      return true;
    }
    return false;
  }
}
