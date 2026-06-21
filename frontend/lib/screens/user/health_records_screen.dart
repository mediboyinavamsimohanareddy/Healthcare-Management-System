import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
      
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
              const SizedBox(width: 16),
              Text('Uploading record...', style: GoogleFonts.poppins()),
            ],
          ),
          duration: const Duration(seconds: 1),
        )
      );

      await Provider.of<HealthRecordProvider>(context, listen: false).uploadRecord(
          token!, 'Prescription ${DateTime.now().millisecond}', 'image', File(pickedFile.path));
          
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF00BFA5),
            content: Text('Record uploaded successfully!', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<HealthRecordProvider>(context).records;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0.5,
      ),
      body: records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.folder_open_rounded, size: 60, color: Color(0xFF00BFA5)),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No records found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload your lab reports and prescriptions\nto keep them secure and handy.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _uploadFile,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: Text(
                      'Upload New Record',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (ctx, i) {
                final rec = records[i];
                final dateFormatted = DateFormat('MMM d, yyyy • h:mm a').format(rec.uploadedAt.toLocal());
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description_rounded, color: Colors.blue, size: 24),
                    ),
                    title: Text(
                      rec.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Uploaded on $dateFormatted',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                    onTap: () {
                      // Implementation for viewing the record
                    },
                  ),
                );
              },
            ),
      floatingActionButton: records.isNotEmpty 
          ? FloatingActionButton.extended(
              onPressed: _uploadFile,
              backgroundColor: const Color(0xFF00BFA5),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Upload',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
              ),
              elevation: 4,
            )
          : null,
    );
  }
}
