import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/Destination.dart';
import '../Widgets/colors.dart';
import '../Widgets/CustomeDrawer.dart';

class DestinationScreen extends StatelessWidget {
  final Destination destination;

  const DestinationScreen({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar style to match ExploreScreen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBackground,
      statusBarIconBrightness: Brightness.light,
    ));

    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header with image, menu, and profile
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

              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(destination.image),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  destination.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}