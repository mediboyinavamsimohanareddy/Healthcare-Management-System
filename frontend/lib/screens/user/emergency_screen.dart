import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Services'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text('Need Help?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Tap below to call emergency services immediately.', textAlign: TextAlign.center),
            const SizedBox(height: 40),
            _buildEmergencyTile(context, 'Ambulance', '102', Icons.medical_services),
            const SizedBox(height: 16),
            _buildEmergencyTile(context, 'Hospital Hotline', '108', Icons.local_hospital),
            const SizedBox(height: 16),
            _buildEmergencyTile(context, 'Police', '100', Icons.local_police),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyTile(BuildContext context, String title, String number, IconData icon) {
    return ListTile(
      tileColor: Colors.red.shade50,
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Call $number'),
      trailing: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.phone, color: Colors.white)),
      onTap: () {
        // use url_launcher in a real app
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling $number...')));
      },
    );
  }
}
