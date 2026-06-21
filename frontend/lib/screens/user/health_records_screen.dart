import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_record_provider.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      Provider.of<HealthRecordProvider>(context, listen: false).fetchUserRecords(token!);
    });
  }

  void _uploadFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await Provider.of<HealthRecordProvider>(context, listen: false).uploadRecord(
          token!, 'Prescription ${DateTime.now().millisecond}', 'image', File(pickedFile.path));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Uploaded!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<HealthRecordProvider>(context).records;

    return Scaffold(
      appBar: AppBar(title: const Text('Health Records'), actions: [IconButton(icon: const Icon(Icons.add), onPressed: _uploadFile)]),
      body: records.isEmpty
          ? const Center(child: Text('No records uploaded yet.'))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (ctx, i) {
                final rec = records[i];
                return ListTile(
                  leading: const Icon(Icons.file_copy, color: Colors.teal),
                  title: Text(rec.title),
                  subtitle: Text('Uploaded on ${rec.uploadedAt.toLocal()}'),
                  onTap: () {
                    // In a real app, open the image/pdf URL
                  },
                );
              },
            ),
    );
  }
}
