import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/constants.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/users/profile'),
      headers: {'x-auth-token': token},
    );

    if (response.statusCode == 200) {
      _user = UserModel.fromJson(json.decode(response.body));
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String token, UserModel updatedUser) async {
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/users/profile'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
      body: json.encode(updatedUser.toJson()),
    );

    if (response.statusCode == 200) {
      _user = UserModel.fromJson(json.decode(response.body));
      notifyListeners();
      return true;
    }
    return false;
  }
}
