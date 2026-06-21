import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../models/doctor_model.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final DoctorModel doctor;
  const AppointmentBookingScreen({super.key, required this.doctor});

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final timeStr = _selectedTime.format(context);
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    bool success = false;
    try {
      success = await Provider.of<AppointmentProvider>(context, listen: false)
          .bookAppointment(token!, widget.doctor.id, widget.doctor.name, dateStr, timeStr);
    } catch (e) {
      debugPrint("Book Appointment UI Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment Booked!')));
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to book appointment.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.doctor.name}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Select Date'),
              subtitle: Text(DateFormat('EEE, MMM d, yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            ListTile(
              title: const Text('Select Time'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                if (picked != null) setState(() => _selectedTime = picked);
              },
            ),
            const Spacer(),
            _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: const Text('Confirm Appointment'),
                ),
          ],
        ),
      ),
    );
  }
}
