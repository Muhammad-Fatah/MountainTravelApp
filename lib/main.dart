import 'package:flutter/material.dart';
import 'package:mounttravel/Screens/HomeScreen.dart';


// Fungsi utama untuk menjalankan aplikasi
void main() {
  runApp(MyApp());
}

// MyApp adalah StatelessWidget karena tidak ada perubahan state
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp untuk aplikasi berbasis Material Design
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      home: HomeScreen(), // Menetapkan halaman utama aplikasi
    );
  }
}
