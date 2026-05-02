import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';

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
          const SnackBar(content: Text("Location updated to your current position!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not fetch location. Please check GPS settings.")),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final user = Session.currentUser;
    final updatedData = {
      "email": user?['email'],
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
      setState(() => isSaving = false);
      if (success) {
        // Update local session name if changed
        Session.currentUser!['name'] = _nameController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Professional Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Basic Information"),
                    const SizedBox(height: 16),
                    _buildTextField(_nameController, "Full Name", Icons.person_outline),
                    _buildTextField(_specializationController, "Specialization", Icons.medical_services_outlined),
                    _buildTextField(_clinicController, "Clinic/Hospital Name", Icons.local_hospital_outlined),
                    _buildTextField(_phoneController, "Contact Number", Icons.phone_outlined, keyboardType: TextInputType.phone),
                    _buildTextField(_districtController, "District / City", Icons.location_city_outlined),
                    _buildTextField(_descriptionController, "About Me / Bio", Icons.info_outline, maxLines: 3),
                    _buildTextField(_workingHoursController, "Working Hours (e.g. 9AM - 6PM)", Icons.access_time),
                    
                    DropdownButtonFormField<String>(
                      value: _doctorType,
                      decoration: InputDecoration(
                        labelText: "Provider Type",
                        prefixIcon: const Icon(Icons.category_outlined, color: AppTheme.primaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: "PRIVATE", child: Text("Private")),
                        DropdownMenuItem(value: "GOVERNMENT", child: Text("Government")),
                        DropdownMenuItem(value: "NGO", child: Text("NGO")),
                      ],
                      onChanged: (v) => setState(() => _doctorType = v!),
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader("Service Details"),
                    const SizedBox(height: 16),
                    _buildTextField(_feeController, "Consultation Fee (₹)", Icons.payments_outlined, keyboardType: TextInputType.number),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader("Location (Map Coordinates)"),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location, size: 18),
                      label: const Text("Get My Current Location"),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_latController, "Latitude", Icons.location_on_outlined, keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildTextField(_lngController, "Longitude", Icons.location_on_outlined, keyboardType: TextInputType.number)),
                      ],
                    ),
                    const Text(
                      "Tip: You can get these from Google Maps by long-pressing any location.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
                        : const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
