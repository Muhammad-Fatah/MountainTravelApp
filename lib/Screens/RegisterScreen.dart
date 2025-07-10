import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Screen untuk pendaftaran pengguna baru.
///
/// Prosesnya melibatkan dua langkah utama:
/// 1. Membuat pengguna baru di Firebase Authentication dengan email dan password.
/// 2. Menyimpan informasi tambahan (nama, alamat, dll.) ke Cloud Firestore
///    dalam koleksi 'users' dengan dokumen ID yang sama dengan UID pengguna.
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // State untuk mengontrol tampilan loading indicator saat proses registrasi.
  bool _isLoading = false;

  final String backgroundImageAssetPath = 'assets/login_image.jpg';

  /// Menangani proses registrasi pengguna.
  void _register() async {
    // Memulai loading indicator.
    setState(() => _isLoading = true);

    try {
      // Langkah 1: Membuat pengguna di Firebase Authentication.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      User? user = userCredential.user;

      // Jika pengguna berhasil dibuat di Auth, lanjutkan ke langkah 2.
      if (user != null) {
        // Langkah 2: Menyimpan data pengguna tambahan ke Firestore.
        // Ini memastikan data profil terpisah dari data autentikasi.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'email': user.email,
          'name': _nameController.text.trim(),
          'address': _addressController.text.trim(),
          'phone': _phoneController.text.trim(),
        });
      }

      // Kembali ke halaman sebelumnya (biasanya LoginScreen) setelah registrasi berhasil.
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Menangani error spesifik dari Firebase Auth (misal: email sudah terdaftar, password lemah).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registrasi gagal')),
      );
    } finally {
      // Pastikan loading indicator selalu berhenti, baik proses berhasil maupun gagal.
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mengatur latar belakang Scaffold menjadi hitam
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image dari asset lokal.
          Image.asset(
            backgroundImageAssetPath,
            fit: BoxFit.cover,
            // Tambahkan colorFilter untuk membuat gambar lebih gelap dan menyatu.
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.6), // Sesuaikan opacity sesuai kebutuhan
          ),
          // Overlay gelap untuk kontras dan konsistensi tema.
          Container(color: Colors.black.withOpacity(0.6)), // Opacity yang lebih tinggi

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Text(
                    'Daftar Akun',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700]), // Warna aksen oranye/kuning
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // Menggunakan warna abu-abu gelap dengan opacity untuk kotak form.
                      color: Colors.grey[850]?.withOpacity(0.9) ?? Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // TextField Nama Lengkap
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: Colors.white), // Warna teks input putih
                          decoration: InputDecoration(
                            hintText: 'Nama Lengkap', // Menggunakan hintText
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.person, color: Colors.white), // Ikon dan warna
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber[700]!),
                            ),
                            fillColor: Colors.grey[800], // Latar belakang TextField
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 16), // Spasi antar TextField
                        // TextField Alamat
                        TextField(
                          controller: _addressController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Alamat',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.location_on, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber[700]!),
                            ),
                            fillColor: Colors.grey[800],
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 16),
                        // TextField Nomor Telepon
                        TextField(
                          controller: _phoneController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Nomor Telepon',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber[700]!),
                            ),
                            fillColor: Colors.grey[800],
                            filled: true,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16),
                        // TextField Email
                        TextField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber[700]!),
                            ),
                            fillColor: Colors.grey[800],
                            filled: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        // TextField Password
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber[700]!),
                            ),
                            fillColor: Colors.grey[800],
                            filled: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Menampilkan loading indicator atau tombol berdasarkan state _isLoading.
                        _isLoading
                            ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!), // Warna loading indicator
                        )
                            : ElevatedButton(
                          onPressed: _register,
                          child: Text(
                            'Daftar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700], // Warna aksen oranye/kuning
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}