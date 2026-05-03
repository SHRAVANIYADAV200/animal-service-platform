import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'otp_verification_screen.dart';
import '../services/lookup_service.dart';

class EditProviderProfileScreen extends StatefulWidget {
  const EditProviderProfileScreen({super.key});

  @override
  State<EditProviderProfileScreen> createState() => _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState extends State<EditProviderProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _clinicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  String _doctorType = "PRIVATE";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Session.currentUser;
    if (user != null) {
      final profile = await ApiService.getProviderProfile(user['email']);
      if (profile != null) {
        setState(() {
          _nameController.text = profile['name'] ?? "";
          _specializationController.text = profile['specialization'] ?? "";
          _clinicController.text = profile['clinicName'] ?? "";
          _phoneController.text = profile['phone'] ?? "";
          _feeController.text = (profile['consultationFee'] ?? 0.0).toString();
          _latController.text = (profile['latitude'] ?? 0.0).toString();
          _lngController.text = (profile['longitude'] ?? 0.0).toString();
          _descriptionController.text = profile['description'] ?? "";
          _workingHoursController.text = profile['workingHours'] ?? "";
          _districtController.text = profile['district'] ?? "";
          _doctorType = profile['doctorType'] ?? "PRIVATE";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _latController.text = position.latitude.toString();
          _lngController.text = position.longitude.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.locationUpdated)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.locationFailed)),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final user = Session.currentUser;
    final email = user?['email'] ?? "";

    // 🛡️ STEP 1: Send OTP for Sensitive Action
    final otpSent = await ApiService.sendOtp(email, "PROFILE_UPDATE");
    
    if (!mounted) return;
    setState(() => isSaving = false);

    if (otpSent) {
      // 🛡️ STEP 2: Verify OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            email: email,
            type: "PROFILE_UPDATE",
            onVerified: () async {
              // 🛡️ STEP 3: Finalize Update
              final updatedData = {
                "email": email,
                "name": _nameController.text,
                "specialization": _specializationController.text,
                "clinicName": _clinicController.text,
                "phone": _phoneController.text,
                "consultationFee": double.tryParse(_feeController.text) ?? 0.0,
                "latitude": double.tryParse(_latController.text) ?? 0.0,
                "longitude": double.tryParse(_lngController.text) ?? 0.0,
                "description": _descriptionController.text,
                "workingHours": _workingHoursController.text,
                "doctorType": _doctorType,
                "district": _districtController.text,
              };

              final success = await ApiService.updateProviderProfile(updatedData);

              if (mounted) {
                if (success) {
                  Session.currentUser!['name'] = _nameController.text;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
                  );
                  Navigator.pop(context); // From OTP
                  Navigator.pop(context); // From Edit Screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdateFailed)),
                  );
                }
              }
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send verification code.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editProfessionalProfile)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(AppLocalizations.of(context)!.basicInformation),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, AppLocalizations.of(context)!.fullName, Icons.person_outline),
                    _buildTextField(_specializationController, AppLocalizations.of(context)!.specialization, Icons.medical_services_outlined),
                    _buildTextField(_clinicController, AppLocalizations.of(context)!.clinicHospitalName, Icons.local_hospital_outlined),
                    _buildTextField(_phoneController, AppLocalizations.of(context)!.contactNumber, Icons.phone_outlined, keyboardType: TextInputType.phone),
                    
                    _buildTextField(_districtController, "District", Icons.location_city_outlined),
                    
                    _buildTextField(_descriptionController, AppLocalizations.of(context)!.aboutMeBio, Icons.info_outline, maxLines: 3),
                    _buildTextField(_workingHoursController, AppLocalizations.of(context)!.workingHoursLabel, Icons.access_time),
                    
                    DropdownButtonFormField<String>(
                      value: _doctorType,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.providerType,
                        prefixIcon: const Icon(Icons.category_outlined, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: [
                        DropdownMenuItem(value: "PRIVATE", child: Text(AppLocalizations.of(context)!.private)),
                        DropdownMenuItem(value: "GOVERNMENT", child: Text(AppLocalizations.of(context)!.government)),
                        DropdownMenuItem(value: "NGO", child: Text(AppLocalizations.of(context)!.ngo)),
                      ],
                      onChanged: (v) => setState(() => _doctorType = v!),
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader(AppLocalizations.of(context)!.serviceDetails),
                    const SizedBox(height: 16),
                    _buildTextField(_feeController, AppLocalizations.of(context)!.consultationFee, Icons.payments_outlined, keyboardType: TextInputType.number),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader(AppLocalizations.of(context)!.locationCoordinates),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location, size: 18),
                       label: Text(AppLocalizations.of(context)!.getMyCurrentLocation),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_latController, AppLocalizations.of(context)!.latitude, Icons.location_on_outlined, keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(_lngController, AppLocalizations.of(context)!.longitude, Icons.location_on_outlined, keyboardType: TextInputType.number)),
                      ],
                    ),
                      Text(AppLocalizations.of(context)!.locationTip,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isSaving 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(AppLocalizations.of(context)!.saveChanges, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
