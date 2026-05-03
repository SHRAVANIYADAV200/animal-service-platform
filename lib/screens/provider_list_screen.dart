import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadProviders();
    _timer = Timer.periodic(const Duration(seconds: 5), (t) => loadProviders(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadProviders({bool silent = false}) async {
    if (!silent) setState(() => isLoading = true);
    final data = await ApiService.getAllProviders(type: filterType);
    if (mounted) {
      setState(() {
        allProviders = data;
        filteredProviders = data;
        isLoading = false;
      });
    }
  }

  void _applyFilter() {
    loadProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.findDoctors)),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                {"key": "All", "label": AppLocalizations.of(context)!.all},
                {"key": "Private", "label": AppLocalizations.of(context)!.private},
                {"key": "Government", "label": AppLocalizations.of(context)!.government},
                {"key": "NGO", "label": AppLocalizations.of(context)!.ngo},
              ].map((filter) {
                String key = filter['key'] as String;
                String label = filter['label'] as String;
                bool isSelected = filterType == key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (v) {
                      setState(() {
                        filterType = key;
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
                    ? _emptyState(AppLocalizations.of(context)!)
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
                  Text(p['specialization'] ?? AppLocalizations.of(context)!.veterinarySpecialist, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text("${p['avgRating'] ?? 0.0} (${p['totalReviews'] ?? 0})", 
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _typeBadge(p['doctorType'] ?? "PRIVATE"),
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

  Widget _typeBadge(String type) {
    Color color;
    switch (type.toUpperCase()) {
      case "GOVERNMENT":
        color = Colors.blue;
        break;
      case "NGO":
        color = Colors.orange;
        break;
      default:
        color = AppTheme.primaryColor;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emptyState(AppLocalizations l) {
    return Center(
      child: Text(l.noDoctorsFound, style: TextStyle(color: Colors.grey.shade400)),
    );
  }
}
