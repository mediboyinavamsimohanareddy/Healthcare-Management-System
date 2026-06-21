import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  List _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  void _fetchAppointments() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/appointments/doctor'),
      headers: {'x-auth-token': token!},
    );
    if (response.statusCode == 200) {
      setState(() => _appointments = json.decode(response.body));
    }
  }

  void _updateStatus(String id, String status) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    await http.put(
      Uri.parse('${AppConstants.baseUrl}/doctors/appointment/$id'),
      headers: {'Content-Type': 'application/json', 'x-auth-token': token!},
      body: json.encode({'status': status}),
    );
    _fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Appointments')),
      body: _appointments.isEmpty
          ? const Center(child: Text('No appointments yet.'))
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (ctx, i) {
                final ap = _appointments[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(ap['userName']),
                    subtitle: Text('${ap['date']} at ${ap['time']} - Status: ${ap['status']}'),
                    trailing: ap['status'] == 'Pending'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _updateStatus(ap['_id'], 'Accepted')),
                              IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => _updateStatus(ap['_id'], 'Rejected')),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
