import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Screen yang memungkinkan pengguna untuk mengedit informasi profil mereka.
///
/// Data profil diambil dari dan disimpan ke koleksi 'users' di Firestore,
/// menggunakan UID pengguna sebagai ID dokumen.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Mengambil instance pengguna yang sedang login. Diasumsikan tidak null di screen ini.
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  // Flag untuk menampilkan loading indicator saat data sedang diambil dari Firestore.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak.
    _nameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  /// Mengambil data profil pengguna dari Firestore dan mengisi text field.
  Future<void> _loadUserProfile() async {
    if (user == null) {
      setState(() => _isLoading = false);
      return; // Keluar jika tidak ada pengguna yang login.
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _usernameController.text = data['username'] ?? '';
      }
    } catch (e) {
      // Sebaiknya tampilkan pesan error ke pengguna jika gagal memuat data.
      print("Gagal memuat profil: $e");
    } finally {
      // Pastikan loading state selalu di-update, baik berhasil maupun gagal.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Menyimpan perubahan data profil ke Firestore.
  Future<void> _saveChanges() async {
    if (user == null) return;

    // Menggunakan `set` dengan `merge: true` lebih aman karena tidak akan
    // menghapus field lain yang mungkin ada di dokumen (seperti 'createdAt').
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'username': _usernameController.text.trim(),
    }, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/default_avatar.jpg') as ImageProvider,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFCCFF00),
                      child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileField("Full name", _nameController),
              _buildProfileField("Phone number", _phoneController),
              _buildProfileField("Email", TextEditingController(text: user?.email ?? ''), enabled: false),
              _buildProfileField("Username", _usernameController),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF00),
                  minimumSize: const Size(double.infinity, 50),
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
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implementasikan logika hapus akun.
                  // Ini akan memerlukan re-autentikasi pengguna dan dialog konfirmasi.
                },
                child: Center(
                  child: Text(
                    "Delete Account",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk membuat text field profil yang konsisten.
  Widget _buildProfileField(String label, TextEditingController controller, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }
}