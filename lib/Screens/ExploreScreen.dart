import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mounttravel/Models/Destination.dart';
import 'package:mounttravel/Screens/DestinationScreen.dart';
import 'package:mounttravel/Services/api_service.dart';
import 'package:mounttravel/Widgets/CustomeDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets//colors.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _index = 0;
  String _searchQuery = "";
  List<Destination> _allDestinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      List<Destination> data = await ApiService.fetchDestinations();
      print("Jumlah data: ${data.length}");
      if (data.isNotEmpty) {
        print("Contoh nama: ${data.first.name}");
        print("Contoh lokasi: ${data.first.description}");
      }
      setState(() {
        _allDestinations = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Fetch error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ));

    List<Destination> filteredDestinations = _allDestinations
        .where((dest) => dest.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        drawer: CustomDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu & Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 30),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                        ? NetworkImage(user.photoURL!)
                        : AssetImage('assets/default_avatar.jpg') as ImageProvider,
                  ),
                ],
              ),
            ),

            // Title
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

            SizedBox(height: 10),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: 'Cari gunung...',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Content
            _isLoading
                ? Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
                : filteredDestinations.isEmpty
                ? Expanded(
              child: Center(
                child: Text(
                  "Tidak ada data ditemukan.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredDestinations.length,
                itemBuilder: (context, i) {
                  final destination = filteredDestinations[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DestinationScreen(destination: destination),
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(destination.image),
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        destination.name,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 6,
                            )
                          ],
                        ),
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
