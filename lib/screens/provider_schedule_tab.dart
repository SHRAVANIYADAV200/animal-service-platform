import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'consultation_detail_screen.dart';

class ProviderScheduleTab extends StatefulWidget {
  const ProviderScheduleTab({super.key});

  @override
  State<ProviderScheduleTab> createState() => _ProviderScheduleTabState();
}

class _ProviderScheduleTabState extends State<ProviderScheduleTab> {
  DateTime selectedDate = DateTime.now();
  List bookings = [];
  bool isLoading = true;
  bool isAvailable = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final user = Session.currentUser;
    final email = user?['email'];
    if (email == null) return;

    final bData = await ApiService.getProviderBookings(email);
    // Filter by accepted status
    final filtered = bData.where((b) => b['status'] == "ACCEPTED").toList();
    
    if (mounted) {
      setState(() {
        bookings = filtered;
        isAvailable = user?['isAvailable'] ?? true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendarStrip(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) => _buildScheduleItem(bookings[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Schedule", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Switch(
                value: isAvailable,
                onChanged: (v) async {
                  setState(() => isAvailable = v);
                  final user = Session.currentUser;
                  final email = user?['email'];
                  if (email != null) {
                    await ApiService.updateAvailability(email, v);
                  }
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: isAvailable ? Colors.green : Colors.grey),
              const SizedBox(width: 8),
              Text(isAvailable ? "Available for new requests" : "Currently Busy", 
                   style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return Container(
      height: 100,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          bool isSelected = date.day == selectedDate.day;
          
          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('E').format(date), 
                       style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
                  Text(date.day.toString(), 
                       style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleItem(Map b) {
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
          Column(
            children: [
              Text(b['appointmentTime']?.split(' ')[0] ?? "09:00", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("AM", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b['serviceType'], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(b['farmerEmail'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultationDetailScreen(booking: b))),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available_outlined, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text("No appointments for this day", style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
