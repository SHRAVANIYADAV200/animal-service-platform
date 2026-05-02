import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({super.key});

  @override
  State<VaccinationScreen> createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  List records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  void loadRecords() async {
    final user = Session.currentUser;
    if (user != null) {
      final data = await ApiService.getFarmerVaccinations(user['email']);
      if (mounted) {
        setState(() {
          records = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text("Vaccination Tracking")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSummaryCard(),
                Expanded(
                  child: records.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: records.length,
                          itemBuilder: (context, index) => _buildVaccineCard(records[index]),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Record", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${records.length} Records", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("Stay updated with vaccinations", style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(Map r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r['animalName'] ?? "Animal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Text("COMPLETED", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _rowInfo(Icons.vaccines, "Vaccine", r['vaccineName']),
          const SizedBox(height: 8),
          _rowInfo(Icons.calendar_today, "Given on", r['dateGiven'] ?? "N/A"),
          const SizedBox(height: 8),
          _rowInfo(Icons.event_repeat, "Next Due", r['nextDueDate'] ?? "Not set"),
        ],
      ),
    );
  }

  Widget _rowInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.vaccines_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No records yet", style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final animalController = TextEditingController();
    final vaccineController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Vaccination"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: animalController, decoration: const InputDecoration(hintText: "Animal Name (e.g. Cow #1)")),
            const SizedBox(height: 12),
            TextField(controller: vaccineController, decoration: const InputDecoration(hintText: "Vaccine Name")),
            const SizedBox(height: 12),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(hintText: "Date (YYYY-MM-DD)", prefixIcon: Icon(Icons.calendar_today, size: 16)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (animalController.text.isNotEmpty && vaccineController.text.isNotEmpty) {
                final user = Session.currentUser;
                await ApiService.addVaccinationRecord(
                  user!['email'],
                  animalController.text,
                  vaccineController.text,
                  dateController.text.isEmpty ? DateTime.now().toString().split(' ')[0] : dateController.text,
                );
                Navigator.pop(context);
                loadRecords();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
