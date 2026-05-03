import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../services/lookup_service.dart';
import '../theme/app_theme.dart';
import 'doctor_detail_screen.dart';

class GovernmentVetsScreen extends StatefulWidget {
  const GovernmentVetsScreen({super.key});

  @override
  State<GovernmentVetsScreen> createState() => _GovernmentVetsScreenState();
}

class _GovernmentVetsScreenState extends State<GovernmentVetsScreen> {
  List vets = [];
  String? selectedDistrict;
  bool isLoading = true;

  final List<String> districts = lookup.districts;

  @override
  void initState() {
    super.initState();
    _loadVets();
  }

  Future<void> _loadVets() async {
    setState(() => isLoading = true);
    // Fetch specifically GOVERNMENT vets
    final data = await ApiService.getAllProviders(type: "GOVERNMENT");
    if (mounted) {
      setState(() {
        vets = data;
        if (selectedDistrict != null) {
          vets = vets.where((v) => 
            (v['district'] ?? "").toString().toLowerCase()
            .contains(selectedDistrict!.toLowerCase())
          ).toList();
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Government Vets"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Find your local Livestock Development Officer (LDO)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (val) {
                    setState(() => selectedDistrict = val.isEmpty ? null : val);
                    _loadVets();
                  },
                  decoration: InputDecoration(
                    hintText: "Search by District",
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : vets.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vets.length,
                        itemBuilder: (context, index) => _vetCard(vets[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _vetCard(Map v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("District: ${v['district'] ?? 'N/A'}", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("FREE CONSULTATION", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: v)));
            },
            icon: const Icon(Icons.chevron_right, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No government vets found in $selectedDistrict", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
