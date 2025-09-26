import 'package:attendance_web/constant/app_assets.dart';
import 'package:attendance_web/constant/app_color.dart';
import 'package:attendance_web/screens/adminscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
 bool _obscureText = true; 

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
              padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 10),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                     Image.asset(AppAssets.logo,scale: 6,),
                     SizedBox(height: 60,),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please Enter your user name & Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                   color:   AppColor.darkGrey
                    ),
                  ),
                  const SizedBox(height: 20),
            
                  // Email
                  TextField(
                                cursorColor: AppColor.primary,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "User Name",
                      suffixIcon: const Icon(Icons.person,color: AppColor.grey,),
                      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColor.primary, 
      
          ),
        ),
        floatingLabelStyle: TextStyle(color: AppColor.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
            _obscureText ? Icons.visibility_off : Icons.visibility,color: AppColor.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
                       focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColor.primary, 
      
          ),
        ),
                floatingLabelStyle: TextStyle(color: AppColor.primary),
      ),),
                  const SizedBox(height: 24),
            
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                      
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminScreen()),
                      );
// Get.to(() => const DashboardScreen());

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18,color: AppColor.white,fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
            
             
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
