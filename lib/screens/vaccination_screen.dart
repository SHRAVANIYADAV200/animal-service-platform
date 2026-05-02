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
      // If it's a doctor, we might want to show records for a specific farmer,
      // but for now, we show the current user's records.
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
    int upcoming = records.where((r) => r['status'] == "UPCOMING").length;
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
              Text("$upcoming upcoming reminders", style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(Map r) {
    bool isUpcoming = r['status'] == "UPCOMING";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUpcoming ? Colors.orange.withOpacity(0.3) : Colors.grey.shade100),
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
                decoration: BoxDecoration(
                  color: isUpcoming ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  r['status'] ?? "COMPLETED",
                  style: TextStyle(
                    color: isUpcoming ? Colors.orange : Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _rowInfo(Icons.vaccines, "Vaccine", r['vaccineName']),
          if (!isUpcoming) ...[
            const SizedBox(height: 8),
            _rowInfo(Icons.calendar_today, "Given on", r['dateGiven'] ?? "N/A"),
          ],
          const SizedBox(height: 8),
          _rowInfo(isUpcoming ? Icons.alarm : Icons.event_repeat, isUpcoming ? "Due on" : "Next Due", r['nextDueDate'] ?? "Not set"),
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
    final dueDateController = TextEditingController();
    String selectedStatus = "COMPLETED";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Add Vaccination"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: "COMPLETED", child: Text("Already Given")),
                    DropdownMenuItem(value: "UPCOMING", child: Text("Set Reminder")),
                  ],
                  onChanged: (v) => setDialogState(() => selectedStatus = v!),
                  decoration: const InputDecoration(labelText: "Type"),
                ),
                const SizedBox(height: 12),
                TextField(controller: animalController, decoration: const InputDecoration(labelText: "Animal Name (e.g. Cow #1)")),
                const SizedBox(height: 12),
                TextField(controller: vaccineController, decoration: const InputDecoration(labelText: "Vaccine Name")),
                const SizedBox(height: 12),
                if (selectedStatus == "COMPLETED")
                  ListTile(
                    title: Text("Date Given: ${dateController.text.isEmpty ? 'Today' : dateController.text}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => dateController.text = picked.toString().split(' ')[0]);
                      }
                    },
                  ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text(selectedStatus == "UPCOMING" ? "Reminder Date: ${dueDateController.text}" : "Next Due Date: ${dueDateController.text.isEmpty ? 'Not set' : dueDateController.text}"),
                  trailing: const Icon(Icons.alarm),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 180)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) {
                      setDialogState(() => dueDateController.text = picked.toString().split(' ')[0]);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (animalController.text.isNotEmpty && vaccineController.text.isNotEmpty) {
                  final user = Session.currentUser;
                  await ApiService.addVaccinationRecord(
                    farmerEmail: user!['email'],
                    animal: animalController.text,
                    vaccine: vaccineController.text,
                    dateGiven: selectedStatus == "COMPLETED" 
                        ? (dateController.text.isEmpty ? DateTime.now().toString().split(' ')[0] : dateController.text)
                        : null,
                    nextDueDate: dueDateController.text.isEmpty ? null : dueDateController.text,
                    status: selectedStatus,
                    providerEmail: user['role'] == 'Service Provider' ? user['email'] : null,
                  );
                  Navigator.pop(context);
                  loadRecords();
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
