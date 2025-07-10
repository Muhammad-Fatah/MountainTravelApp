import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/Colors.dart';
import '../Widgets/CustomeDrawer.dart';

/// Screen untuk menampilkan dan mengedit data profil pengguna.
///
/// Menggunakan `StreamSubscription` (`.snapshots().listen`) untuk mendapatkan
/// pembaruan data profil secara real-time dari Firestore.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers untuk setiap field input.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  // State untuk mengontrol mode edit dan tampilan loading.
  bool _isEditing = false;
  bool _isLoading = true;

  // Variabel untuk menyimpan instance dan data dari Firebase.
  User? _currentUser;
  String? _userId;

  final String _defaultAvatarAssetPath = 'assets/default_avatar.jpg';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    // Selalu dispose controllers untuk mencegah kebocoran memori (memory leaks).
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Mengambil data pengguna dari Firestore secara real-time.
  ///
  /// Menggunakan .snapshots().listen() agar UI otomatis diperbarui
  /// jika ada perubahan data di database dari sumber lain.
  void _loadUserData() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _userId = _currentUser?.uid;

    if (_userId == null) {
      if (mounted) setState(() => _isLoading = false);
      return; // Keluar jika tidak ada pengguna yang login.
    }

    FirebaseFirestore.instance.collection('users').doc(_userId).snapshots().listen(
          (snapshot) {
        if (snapshot.exists && mounted) {
          final data = snapshot.data()!;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? _currentUser?.email ?? ''; // Fallback ke email dari Auth
          _addressController.text = data['address'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          setState(() => _isLoading = false);
        } else {
          // Handle kasus jika dokumen pengguna belum ada
          if(mounted) setState(() => _isLoading = false);
        }
      },
      onError: (error) {
        print("Gagal memuat profil: $error");
        if (mounted) setState(() => _isLoading = false);
      },
    );
  }

  /// Menyimpan data yang telah diubah ke Firestore.
  void _saveUserData() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).set({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        // Email biasanya tidak diubah di sini, tapi di-merge untuk jaga-jaga.
        'email': _emailController.text.trim(),
      }, SetOptions(merge: true)); // `merge: true` mencegah field lain terhapus.

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Gagal menyimpan data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        drawer: const CustomDrawer(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: _currentUser?.photoURL != null && _currentUser!.photoURL!.isNotEmpty
                        ? NetworkImage(_currentUser!.photoURL!)
                        : AssetImage(_defaultAvatarAssetPath) as ImageProvider,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Profil Saya',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileField(_nameController, 'Nama Lengkap', Icons.person, _isEditing),
              const SizedBox(height: 16),
              _buildProfileField(_emailController, 'Email', Icons.email, false), // Email tidak bisa di-edit.
              const SizedBox(height: 16),
              _buildProfileField(_addressController, 'Alamat', Icons.location_on, _isEditing),
              const SizedBox(height: 16),
              _buildProfileField(_phoneController, 'Nomor Telepon', Icons.phone, _isEditing, TextInputType.phone),
              const SizedBox(height: 30),

              // Tampilan tombol akan berubah tergantung pada mode `_isEditing`.
              _isEditing
                  ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Simpan', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Batal', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.primary)),
                    ),
                  ),
                ],
              )
                  : ElevatedButton(
                onPressed: () => setState(() => _isEditing = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Edit Profil', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk membangun field input yang konsisten.
  Widget _buildProfileField(TextEditingController controller, String labelText, IconData icon, bool isEditable,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      enabled: isEditable,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        // Style saat field tidak aktif (disabled).
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
      ),
    );
  }
}