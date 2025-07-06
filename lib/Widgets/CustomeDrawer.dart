import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback? onClose;

  const CustomDrawer({this.onClose});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      width: MediaQuery.of(context).size.width, // Full screen drawer
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuItem("Explore", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/explore');
                  }),
                  SizedBox(height: 20),
                  _buildMenuItem("Profile", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  }),
                  SizedBox(height: 20),
                  _buildMenuItem("Log Out", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  }),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: onClose ?? () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
