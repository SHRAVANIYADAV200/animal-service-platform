import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'otp_verification_screen.dart';
import '../services/session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  String role = "Farmer";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.createAccount),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.joinUs,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l.joinUsSubtitle,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: l.fullName,
                  prefixIcon:
                      const Icon(Icons.person_outline, size: 20),
                ),
                validator: (v) => v!.isEmpty ? l.required : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: l.email,
                  prefixIcon:
                      const Icon(Icons.email_outlined, size: 20),
                ),
                validator: (v) =>
                    v!.contains("@") ? null : l.invalidEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: l.phoneNumber,
                  prefixIcon:
                      const Icon(Icons.phone_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: l.password,
                  prefixIcon:
                      const Icon(Icons.lock_outline, size: 20),
                ),
                validator: (v) =>
                    v!.length >= 6 ? null : l.minCharacters,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                      Icons.assignment_ind_outlined,
                      size: 20),
                ),
                items: [
                  DropdownMenuItem(
                      value: "Farmer", child: Text(l.farmer)),
                  DropdownMenuItem(
                      value: "Service Provider",
                      child: Text(l.serviceProvider)),
                ],
                onChanged: (v) => setState(() => role = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isLoading ? null : _handleRegister,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(l.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final l = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    // 🛡️ STEP 1: Send OTP
    final otpSent = await ApiService.sendOtp(emailController.text, "REGISTRATION");
    
    if (!mounted) return;
    setState(() => isLoading = false);

    if (otpSent) {
      // 🛡️ STEP 2: Navigate to OTP Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            email: emailController.text,
            type: "REGISTRATION",
            onVerified: () async {
              // 🛡️ STEP 3: Finalize Registration
              final result = await ApiService.register(
                nameController.text,
                emailController.text,
                passwordController.text,
                phoneController.text,
                role,
              );
              if (mounted) {
                if (result != null) {
                  await Session.setMfaVerified(emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.accountCreated)),
                  );
                  Navigator.pop(context); // Go back from OTP
                  Navigator.pop(context); // Go back from Register
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.registrationFailed)),
                  );
                }
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send verification code. Please try again.")),
      );
    }
  }
}
