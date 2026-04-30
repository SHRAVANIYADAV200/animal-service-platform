import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>(); // ✅ FORM KEY

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  String role = "Farmer";
  bool agree = false;

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [

          // 🔥 TOP IMAGE
          SizedBox(
            height: screenHeight * 0.30,
            width: double.infinity,
            child: Image.asset(
              "assets/images/register.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey, // ✅ IMPORTANT
                child: Column(
                  children: [

                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Join us to care for your pets!",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // 👤 NAME
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter name" : null,
                    ),

                    const SizedBox(height: 10),

                    // 📧 EMAIL
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        } else if (!value.endsWith("@gmail.com")) {
                          return "Email must be @gmail.com";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // 🔒 PASSWORD
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        } else if (value.length < 8) {
                          return "Minimum 8 characters required";
                        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Add at least 1 Capital letter";
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return "Add 1 special character";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // 🔽 ROLE
                    DropdownButtonFormField<String>(
                      value: role,
                      items: const [
                        DropdownMenuItem(value: "Farmer", child: Text("Farmer")),
                        DropdownMenuItem(
                          value: "Service Provider",
                          child: Text("Service Provider"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          role = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ CHECKBOX
                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "I agree to Terms of Service & Privacy Policy.",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔘 SIGN UP
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && agree) {

                            final response = await ApiService.register(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              phoneController.text,
                              role,
                            );

                            if (response != null && response['id'] != null) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Registration Successful")),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Registration Failed")),
                              );
                            }

                          } else if (!agree) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please accept Terms & Policy"),
                              ),
                            );
                          }
                        },
                        child: const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 LOGIN LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.blue,
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
          ),
        ],
      ),
    );
  }
}