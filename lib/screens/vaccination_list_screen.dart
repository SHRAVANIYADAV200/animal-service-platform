import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'add_vaccination_screen.dart';

class VaccinationListScreen extends StatefulWidget {
  const VaccinationListScreen({super.key});

  @override
  State<VaccinationListScreen> createState() => _VaccinationListScreenState();
}

class _VaccinationListScreenState extends State<VaccinationListScreen> {
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

  String _getBadgeStatus(String? dueDateStr) {
    if (dueDateStr == null || dueDateStr.isEmpty) return "COMPLETED";
    try {
      DateTime dueDate = DateTime.parse(dueDateStr);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      
      if (dueDate.isBefore(today)) return "OVERDUE";
      if (dueDate.difference(today).inDays <= 7) return "DUE SOON";
    } catch (e) {
      return "COMPLETED";
    }
    return "UPCOMING";
  }

  Color _getBadgeColor(String status) {
    switch (status) {
      case "OVERDUE": return Colors.red;
      case "DUE SOON": return Colors.orange;
      case "UPCOMING": return Colors.blue;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l.vaccinationTracking),
        actions: [
          IconButton(onPressed: loadRecords, icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(l),
                Expanded(
                  child: records.isEmpty
                      ? _buildEmptyState(l)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: records.length,
                          itemBuilder: (context, index) =>
                              _buildVaccineCard(records[index], l),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVaccinationScreen()),
          );
          loadRecords();
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l.addRecord, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    int overdue = records.where((r) => _getBadgeStatus(r['nextDueDate']) == "OVERDUE").length;
    int dueSoon = records.where((r) => _getBadgeStatus(r['nextDueDate']) == "DUE SOON").length;

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _headerStat(overdue.toString(), "OVERDUE", Colors.red),
          _headerStat(dueSoon.toString(), "DUE SOON", Colors.orange),
          _headerStat(records.length.toString(), "TOTAL", Colors.blue),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildVaccineCard(Map r, AppLocalizations l) {
    String status = _getBadgeStatus(r['nextDueDate']);
    Color color = _getBadgeColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r['animalName'] ?? "Animal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(r['vaccineName'] ?? "Vaccine", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                    const Divider(height: 24),
                    Row(
                      children: [
                        _infoItem(Icons.calendar_today, "Given", r['dateGiven'] ?? "N/A"),
                        const Spacer(),
                        _infoItem(Icons.event_repeat, "Next Due", r['nextDueDate'] ?? "Not Set"),
                      ],
                    ),
                    if (r['notes'] != null && r['notes'].toString().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Text(r['notes'], style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.vaccines_outlined, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(l.noRecordsYet, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
        ],
      ),
    );
  }
}
