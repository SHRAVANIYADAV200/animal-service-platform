import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'doctor_detail_screen.dart';

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({super.key});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  List allProviders = [];
  List filteredProviders = [];
  String filterType = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }

  void loadProviders() async {
    setState(() => isLoading = true);
    final data = await ApiService.getAllProviders();
    if (mounted) {
      setState(() {
        allProviders = data;
        _applyFilter();
        isLoading = false;
      });
    }
  }

  void _applyFilter() {
    if (filterType == "All") {
      filteredProviders = allProviders;
    } else {
      filteredProviders = allProviders.where((p) {
        // If doctorType is null, we default to PRIVATE to match the UI fallback
        String type = (p['doctorType'] ?? "PRIVATE").toString().toUpperCase();
        return type == filterType.toUpperCase();
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text("Find Doctors")),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ["All", "Private", "Government", "NGO"].map((type) {
                bool isSelected = filterType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (v) {
                      setState(() {
                        filterType = type;
                        _applyFilter();
                      });
                    },
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProviders.isEmpty
                    ? _emptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredProviders.length,
                        itemBuilder: (context, index) => _providerCard(filteredProviders[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _providerCard(Map p) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorDetailScreen(doctor: p)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
              child: const Icon(Icons.person, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(p['specialization'] ?? "Veterinary Specialist", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text("${p['avgRating'] ?? 0.0}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(p['doctorType'] ?? "PRIVATE", style: TextStyle(color: AppTheme.primaryColor.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined, color: AppTheme.primaryColor),
              onPressed: () => launchUrl(Uri.parse("tel:${p['phone']}")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text("No doctors found", style: TextStyle(color: Colors.grey.shade400)),
    );
  }
}
