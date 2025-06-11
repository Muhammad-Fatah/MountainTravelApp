import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mounttravel/Models/Destination.dart';
import 'package:mounttravel/Screens/DestinationScreen.dart';
import 'package:mounttravel/Services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _selectedIndex = 0;
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
      setState(() {
        _allDestinations = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Gagal mengambil data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    List<Destination> filteredDestinations = _allDestinations
        .where((dest) => dest.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mountain Explore',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Icon(
                    Icons.notifications,
                    size: 28,
                  )
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari gunung...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Body Content
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : filteredDestinations.isEmpty
                ? Expanded(child: Center(child: Text("Tidak ada data ditemukan.")))
                : Expanded(
              child: PageView.builder(
                itemCount: filteredDestinations.length,
                controller: PageController(viewportFraction: isPortrait ? 0.6 : 0.4),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (context, i) {
                  final destination = filteredDestinations[i];
                  return Transform.scale(
                    scale: i == _index ? 1.0 : 0.9,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DestinationScreen(destination: destination),
                        ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(destination.image),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                      offset: Offset(2, 3),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            destination.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
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
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: GNav(
            gap: 8,
            activeColor: Colors.blue,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            duration: Duration(milliseconds: 800),
            tabBackgroundColor: Colors.grey.shade200,
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.favorite_border, text: 'Favorite'),
              GButton(icon: Icons.map, text: 'Map'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
