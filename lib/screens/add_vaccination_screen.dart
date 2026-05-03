import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';

class AddVaccinationScreen extends StatefulWidget {
  final int? animalId;
  final String? animalName;

  const AddVaccinationScreen({super.key, this.animalId, this.animalName});

  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _animalController = TextEditingController();
  final TextEditingController _vaccineController = TextEditingController();
  final TextEditingController _dateGivenController = TextEditingController();
  final TextEditingController _nextDueController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _isLoading = false;
  int? _selectedAnimalId;

  @override
  void initState() {
    super.initState();
    if (widget.animalName != null) {
      _animalController.text = widget.animalName!;
    }
    _selectedAnimalId = widget.animalId;
  }


  Future<void> _selectDate(BuildContext context, TextEditingController controller, {DateTime? firstDate, DateTime? lastDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = Session.currentUser;

    final record = {
      "farmerEmail": user!['email'],
      "animalName": _animalController.text,
      "vaccineName": _vaccineController.text,
      "dateGiven": _dateGivenController.text.isEmpty ? null : _dateGivenController.text,
      "nextDueDate": _nextDueController.text.isEmpty ? null : _nextDueController.text,
      "notes": _notesController.text,
      "status": _dateGivenController.text.isNotEmpty ? "COMPLETED" : "UPCOMING",
      "providerEmail": user['role'] == 'Service Provider' ? user['email'] : null,
    };

    if (_selectedAnimalId != null) {
      await ApiService.addAnimalVaccination(_selectedAnimalId!, record);
    } else {
      // Fallback to general add if no specific animal selected
      await ApiService.addVaccinationRecord(
        farmerEmail: user['email'],
        animal: _animalController.text,
        vaccine: _vaccineController.text,
        dateGiven: _dateGivenController.text,
        nextDueDate: _nextDueController.text,
        status: _dateGivenController.text.isNotEmpty ? "COMPLETED" : "UPCOMING",
        notes: _notesController.text,
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.addVaccination)),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildTextField(_animalController, l.animalName, Icons.pets_outlined, enabled: widget.animalId == null),
                  
                  _buildTextField(_vaccineController, l.vaccineName, Icons.vaccines_outlined),
                  const SizedBox(height: 16),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePickerField(_dateGivenController, l.dateGiven, Icons.calendar_today, context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDatePickerField(_nextDueController, l.nextDueDate, Icons.event_repeat, context, isFuture: true),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  _buildTextField(_notesController, "Notes (Optional)", Icons.note_alt_outlined, maxLines: 3),
                  
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(l.save, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label, IconData icon, BuildContext context, {bool isFuture = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () => _selectDate(context, controller, 
          firstDate: isFuture ? DateTime.now() : DateTime(2000),
          lastDate: isFuture ? DateTime.now().add(const Duration(days: 365*5)) : DateTime.now(),
        ),
      ),
    );
  }
}
