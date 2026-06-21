import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bloodController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  String? _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _ageController.text = user.age?.toString() ?? '';
      _phoneController.text = user.phone;
      _bloodController.text = user.bloodGroup ?? '';
      _medicalHistoryController.text = user.medicalHistory ?? '';
      
      // Ensure gender matches the items exactly
      if (['Male', 'Female', 'Other'].contains(user.gender)) {
        _gender = user.gender;
      }
    }
  }

  void _save() async {
    setState(() => _isLoading = true);
    
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    
    final updatedUser = UserModel(
      id: user!.id,
      name: _nameController.text.trim(),
      email: user.email,
      phone: _phoneController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      gender: _gender,
      bloodGroup: _bloodController.text.trim(),
      medicalHistory: _medicalHistoryController.text.trim(),
    );

    bool success = false;
    try {
      success = await Provider.of<UserProvider>(context, listen: false).updateProfile(token!, updatedUser);
    } catch (e) {
      debugPrint("Profile Update Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF00BFA5),
            content: Text('Profile Updated Successfully!', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          )
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade400,
            content: Text('Failed to update profile.', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          )
        );
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isMultiLine = false, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: isMultiLine ? 3 : 1,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: isMultiLine ? null : Icon(icon, color: const Color(0xFF00BFA5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header with Avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF00897B), Color(0xFF00BFA5)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade50,
                      child: Text(
                        _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00BFA5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70), // Spacing for avatar
            
            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Full Name', _nameController, Icons.person_outline),
                    _buildTextField('Age', _ageController, Icons.calendar_today_outlined, keyboardType: TextInputType.number),
                    _buildTextField('Phone Number', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                    
                    // Gender Dropdown
                    Text(
                      'Gender',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E293B)),
                      items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) => setState(() => _gender = val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.transgender_outlined, color: Color(0xFF00BFA5)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField('Blood Group', _bloodController, Icons.water_drop_outlined),
                    _buildTextField('Medical History', _medicalHistoryController, Icons.medical_information_outlined, isMultiLine: true),
                    
                    const SizedBox(height: 12),
                    
                    // Save Button
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00BFA5),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Save Profile',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
