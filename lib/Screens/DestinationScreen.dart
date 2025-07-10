import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/Destination.dart';
import '../Widgets/Colors.dart';

// Screen yang menampilkan detail dari satu objek [Destination].
class DestinationScreen extends StatelessWidget {
  final Destination destination;

  // Path ke asset gambar fallback.
  final String _defaultImageAssetPath = 'assets/default_mountain.jpg';
  final String _defaultAvatarAssetPath = 'assets/default_avatar.jpg';

  const DestinationScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan warna dan ikon status bar agar kontras dengan background.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ));

    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                          ? NetworkImage(user.photoURL!)
                          : AssetImage(_defaultAvatarAssetPath) as ImageProvider,
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image.network menangani state loading dan error secara internal.
                    // Jika gagal, akan menampilkan gambar fallback dari asset.
                    Image.network(
                      destination.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Sebaiknya log error ini ke layanan monitoring (Sentry, Firebase Crashlytics).
                        print('Error memuat gambar: $error');
                        return Image.asset(
                          _defaultImageAssetPath,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    // Gradient overlay untuk memastikan teks di atas gambar (jika ada) tetap terbaca.
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.terrain, color: Colors.white70, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          'Ketinggian: ${destination.altitude}',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Deskripsi:',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      destination.description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}