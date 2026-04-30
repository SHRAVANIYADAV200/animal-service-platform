import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'farmer_screen.dart';
import 'service_provider_dashboard.dart';
import '../services/api_service.dart';
import '../services/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  String role = "Farmer";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          // 🔥 FULL BACKGROUND IMAGE
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/splash.png", // 👉 same image use kar
              fit: BoxFit.cover,
            ),
          ),

          // 🔙 BACK BUTTON
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // 🔹 TOP TEXT
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [

                const Icon(Icons.pets, size: 40, color: Colors.green),

                const SizedBox(height: 5),

                const Text(
                  "Animal Service Platform",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Smart Welfare",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 LOGIN CARD
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📱 PHONE
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔒 PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 ROLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Radio(
                        value: "Farmer",
                        groupValue: role,
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                      const Text("Farmer"),

                      Radio(
                        value: "Service Provider",
                        groupValue: role,
                        onChanged: (value) {
                          setState(() {
                            role = value!;
                          });
                        },
                      ),
                      const Text("Service Provider"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔘 LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        final user = await ApiService.login(
                          emailController.text,
                          passwordController.text,
                        );
                        Session.currentUser = user;
                        print("FULL RESPONSE = $user");
                        print("ROLE = ${user?['role']}");

                        if (user != null) {
                          String userRole = user['role'].toString().trim();

                          if (userRole == "Farmer") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FarmerScreen(),
                              ),
                            );
                          } else if (userRole == "Service Provider") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ServiceProviderDashboard(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Unknown role: $userRole")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Failed")),
                          );
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 SIGN UP LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
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
}