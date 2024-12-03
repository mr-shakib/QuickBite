import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:quickbite/pages/auth/login.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * -0.1,
            left: 0,
            child: Transform.rotate(
              angle: pi, // 180 degrees in radians
              child: Blob(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.85,
            left: 60,
            child: Blob(),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Moshimoshi',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A5A5A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'welcome back',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      _buildStyledTextField(
                        controller: _nameController,
                        hintText: 'Full Name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      _buildStyledTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      _buildStyledTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        suffixIcon: Icons.visibility_off,
                      ),
                      const SizedBox(height: 20),
                      _buildStyledTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        suffixIcon: Icons.visibility_off,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xFF5A5A5A),
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _signUp(context),
                            child: _buildGradientButton(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already Registered?',
                              style: TextStyle(
                                color: Color(0xFF5A5A5A),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: const Text(
                                'Login Instead',
                                style: TextStyle(
                                  color: Color(0xFF60ADA4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF5A5A5A).withOpacity(0.6),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF5A5A5A).withOpacity(0.6),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: const Color(0xFF5A5A5A).withOpacity(0.6),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA186), Color(0xFFFFD1A4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pushReplacement(
          // Navigate to home or login page
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Assuming you want to send them to login after
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text('The password provided is too weak.')));
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text('The account already exists for that email.')));
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(title: Text(e.toString())));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text('Passwords do not match')));
    }
  }
}
