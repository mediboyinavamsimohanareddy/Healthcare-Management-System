import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      _gender = user.gender;
    }
  }

  void _save() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    
    final updatedUser = UserModel(
      id: user!.id,
      name: _nameController.text,
      email: user.email,
      phone: _phoneController.text,
      age: int.tryParse(_ageController.text),
      gender: _gender,
      bloodGroup: _bloodController.text,
      medicalHistory: _medicalHistoryController.text,
    );

    final success = await Provider.of<UserProvider>(context, listen: false).updateProfile(token!, updatedUser);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(controller: _bloodController, decoration: const InputDecoration(labelText: 'Blood Group', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _medicalHistoryController, decoration: const InputDecoration(labelText: 'Medical History', border: OutlineInputBorder()), maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }
}
