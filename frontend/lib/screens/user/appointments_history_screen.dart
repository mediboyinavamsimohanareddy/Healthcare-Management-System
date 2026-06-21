import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';

class AppointmentsHistoryScreen extends StatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  State<AppointmentsHistoryScreen> createState() => _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState extends State<AppointmentsHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      Provider.of<AppointmentProvider>(context, listen: false).fetchUserAppointments(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentProvider>(context).appointments;
    final token = Provider.of<AuthProvider>(context).token;

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: appointments.isEmpty
          ? const Center(child: Text('No appointments found.'))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (ctx, i) {
                final ap = appointments[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(ap.doctorName),
                    subtitle: Text('${ap.date} at ${ap.time} - Status: ${ap.status}'),
                    trailing: ap.status == 'Pending'
                        ? TextButton(
                            onPressed: () => Provider.of<AppointmentProvider>(context, listen: false).cancelAppointment(token!, ap.id),
                            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
