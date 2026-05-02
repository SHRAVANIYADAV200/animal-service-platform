import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PharmacyScreen extends StatelessWidget {
  const PharmacyScreen({super.key});

  final List<Map<String, String>> medicines = const [
    {"name": "Calcium Supplement", "price": "₹240", "desc": "Improves bone health in cattle"},
    {"name": "Anti-Fungal Spray", "price": "₹150", "desc": "Effective against skin infections"},
    {"name": "Digestive Powder", "price": "₹120", "desc": "Helps in better digestion"},
    {"name": "Vitamin B Complex", "price": "₹310", "desc": "Essential for general growth"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text("Animal Pharmacy")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final m = medicines[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.teal.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.medication, color: Colors.teal),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(m['desc']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(m['price']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 30),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        foregroundColor: AppTheme.primaryColor,
                        elevation: 0,
                      ),
                      child: const Text("Buy", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
