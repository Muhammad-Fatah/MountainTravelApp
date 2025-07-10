import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mounttravel/Models/Destination.dart';
import 'package:mounttravel/Screens/DestinationScreen.dart';
import 'package:mounttravel/Services/Api_service.dart';
import 'package:mounttravel/Widgets/CustomeDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/Colors.dart';

/// Screen utama yang menampilkan daftar destinasi yang bisa dijelajahi.
///
/// Fitur utama screen ini adalah mengambil data dari API, menampilkan dalam bentuk
/// daftar, dan menyediakan fungsionalitas pencarian secara real-time.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Menyimpan query pencarian dari pengguna.
  String _searchQuery = "";
  // Menyimpan daftar asli semua destinasi dari API.
  List<Destination> _allDestinations = [];
  // Mengontrol state loading untuk menampilkan CircularProgressIndicator.
  bool _isLoading = true;

  // Path ke asset gambar fallback jika gambar dari network gagal dimuat.
  final String _defaultImageAssetPath = 'assets/default_mountain.jpg';
  final String _defaultAvatarAssetPath = 'assets/default_avatar.jpg';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Mengambil data destinasi dari ApiService.
  ///
  /// Fungsi ini menangani state loading dan juga potensi error saat pemanggilan API
  /// menggunakan blok try-catch untuk memastikan aplikasi tetap stabil.
  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchDestinations();
      if (mounted) {
        setState(() {
          _allDestinations = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Fetch error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        // Memberi feedback ke pengguna jika terjadi kegagalan.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan tampilan status bar agar konsisten dengan tema gelap.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ));

    // Logika untuk memfilter destinasi berdasarkan query pencarian.
    // Dijalankan setiap kali UI di-build ulang untuk hasil yang instan.
    final List<Destination> filteredDestinations = _allDestinations
        .where((dest) => dest.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        drawer: const CustomDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Explore',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Cari gunung...',
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Bagian ini secara dinamis menampilkan UI berdasarkan state:
            // 1. Tampilkan loading indicator jika `_isLoading` true.
            // 2. Tampilkan pesan "Tidak ada data" jika data kosong.
            // 3. Tampilkan ListView jika data tersedia.
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : filteredDestinations.isEmpty
                  ? const Center(child: Text("Tidak ada data ditemukan.", style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredDestinations.length,
                itemBuilder: (context, i) {
                  final destination = filteredDestinations[i];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DestinationScreen(destination: destination),
                    )),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image.network menangani state loading dan error internal,
                          // dan akan menampilkan gambar fallback jika gagal.
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              destination.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  _defaultImageAssetPath,
                                  fit: BoxFit.cover,
                                  // Memberi overlay gelap agar konsisten dengan gambar yg berhasil dimuat
                                  color: Colors.black.withOpacity(0.4),
                                  colorBlendMode: BlendMode.darken,
                                );
                              },
                            ),
                          ),
                          // Gradient overlay untuk meningkatkan keterbacaan teks.
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                destination.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: const [Shadow(color: Colors.black, blurRadius: 6)],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}