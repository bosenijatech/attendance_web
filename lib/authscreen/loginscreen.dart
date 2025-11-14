


import 'package:attendance_web/constant/app_assets.dart';
import 'package:attendance_web/constant/app_color.dart';
import 'package:attendance_web/screens/adminscreen.dart';
import 'package:flutter/material.dart';
import '../services/attendance_apiservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  // Login function
  void login() async {
    setState(() {
      _isLoading = true;
    });

    final apiService = AttendanceApiService();

    try {
      final result = await apiService.loginUser(
        username: emailController.text,
        password: passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result.status == true) {
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result.token ?? '');

        // Navigate to AdminScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: AppColor.primary,
              child: Center(
                child: Image.asset(
                  AppAssets.logo,
                  width: 250,
                ),
              ),
            ),
          ),

          // Right Side - Login Form
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(AppAssets.logo, scale: 6),
                  const SizedBox(height: 60),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please Enter your user name & Password",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColor.darkGrey),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextField(
                    cursorColor: AppColor.primary,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "User Name",
                      suffixIcon: const Icon(
                        Icons.person,
                        color: AppColor.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColor.primary,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(color: AppColor.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    cursorColor: AppColor.primary,
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColor.primary,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(color: AppColor.primary),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
