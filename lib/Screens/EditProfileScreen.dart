import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _usernameController.text = data['username'] ?? '';
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'username': _usernameController.text.trim(),
        'email': user!.email,
        'photoURL': user!.photoURL,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Edit Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : AssetImage('assets/default_avatar.jpg') as ImageProvider,
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFCCFF00),
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildProfileField("Full name", _nameController),
              _buildProfileField("Phone number", _phoneController),
              _buildProfileField("Email", TextEditingController(text: user?.email ?? ''), enabled: false),
              _buildProfileField("Username", _usernameController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCCFF00),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Aksi hapus akun
                },
                child: Center(
                  child: Text(
                    "Delete Account",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, {bool enabled = true}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

