import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isEditing = false;
  Map<String, dynamic> userData = {};

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final bioController = TextEditingController();
  final occupationController = TextEditingController();
  final websiteController = TextEditingController();
  final socialMediaController = TextEditingController();
  final additionalInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        userData = data;
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        dateOfBirthController.text = data['dateOfBirth'] ?? '';
        phoneController.text = data['phoneNumber'] ?? '';
        addressController.text = data['address'] ?? '';
        bioController.text = data['bio'] ?? '';
        occupationController.text = data['occupation'] ?? '';
        websiteController.text = data['website'] ?? '';
        socialMediaController.text = data['socialMedia'] ?? '';
        additionalInfoController.text = data['additionalInfo'] ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'name': nameController.text,
      'dateOfBirth': dateOfBirthController.text,
      'phoneNumber': phoneController.text,
      'address': addressController.text,
      'bio': bioController.text,
      'occupation': occupationController.text,
      'website': websiteController.text,
      'socialMedia': socialMediaController.text,
      'additionalInfo': additionalInfoController.text,
    });

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Изменения сохранены')),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
      await user!.delete();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF8E1F), width: 2),
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Профиль', style: TextStyle(color: Colors.black)),
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit, color: const Color(0xFFFF8E1F)),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFF8E1F)),
            tooltip: 'Выйти',
            onPressed: _signOut,
          ),
        ],
      ),
      body: userData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTextField('Имя', nameController, enabled: isEditing),
                _buildTextField('Email', emailController, enabled: false),
                _buildTextField('Дата рождения', dateOfBirthController, enabled: isEditing),
                _buildTextField('Телефон', phoneController, enabled: isEditing),
                _buildTextField('Адрес', addressController, enabled: isEditing),
                _buildTextField('Биография', bioController, enabled: isEditing),
                _buildTextField('Профессия', occupationController, enabled: isEditing),
                _buildTextField('Веб-сайт', websiteController, enabled: isEditing),
                _buildTextField('Соцсети', socialMediaController, enabled: isEditing),
                _buildTextField('Доп. информация', additionalInfoController, enabled: isEditing),
                const SizedBox(height: 24),
                if (isEditing) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save),
                      label: const Text('Сохранить изменения'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8E1F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Удалить аккаунт', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
