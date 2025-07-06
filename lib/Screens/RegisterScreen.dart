import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      User? user = userCredential.user;

      if (user != null) {
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

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Registrasi gagal')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.6)),
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
                        color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration:
                          InputDecoration(labelText: 'Nama Lengkap'),
                        ),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(labelText: 'Alamat'),
                        ),
                        TextField(
                          controller: _phoneController,
                          decoration:
                          InputDecoration(labelText: 'Nomor Telepon'),
                          keyboardType: TextInputType.phone,
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                            onPressed: _register, child: Text('Daftar')),
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


