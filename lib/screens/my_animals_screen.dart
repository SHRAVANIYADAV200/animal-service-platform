import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'add_animal_screen.dart';

class MyAnimalsScreen extends StatefulWidget {
  const MyAnimalsScreen({super.key});

  @override
  State<MyAnimalsScreen> createState() => _MyAnimalsScreenState();
}

class _MyAnimalsScreenState extends State<MyAnimalsScreen> {
  List animals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final user = Session.currentUser;
    if (user != null) {
      final data = await ApiService.getFarmerAnimals(user['email']);
      if (mounted) {
        setState(() {
          animals = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("My Animals"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAnimalScreen()));
              _loadAnimals();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : animals.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: animals.length,
                  itemBuilder: (context, index) => _animalCard(animals[index]),
                ),
    );
  }

  Widget _animalCard(Map a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.farmerPrimary.withOpacity(0.1),
          child: const Icon(Icons.pets, color: AppTheme.farmerPrimary),
        ),
        title: Text(a['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${a['species']} • ${a['breed'] ?? 'Unknown Breed'}"),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No animals added yet", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddAnimalScreen()));
              _loadAnimals();
            },
            child: const Text("Add Your First Animal"),
          ),
        ],
      ),
    );
  }
}
