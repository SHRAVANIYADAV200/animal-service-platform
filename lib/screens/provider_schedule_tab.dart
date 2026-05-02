import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session.dart';
import '../theme/app_theme.dart';
import 'consultation_detail_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class ProviderScheduleTab extends StatefulWidget {
  const ProviderScheduleTab({super.key});

  @override
  State<ProviderScheduleTab> createState() => _ProviderScheduleTabState();
}

class _ProviderScheduleTabState extends State<ProviderScheduleTab> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  List allBookings = [];
  List filteredBookings = [];
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
    final accepted = bData.where((b) => b['status'] == "ACCEPTED").toList();
    
    if (mounted) {
      setState(() {
        allBookings = accepted;
        isAvailable = user?['isAvailable'] ?? true;
        _filterBookings();
        isLoading = false;
      });
    }
  }

  void _filterBookings() {
    final dateStr = selectedDate.toString().split(' ')[0];
    setState(() {
      filteredBookings = allBookings.where((b) => b['appointmentDate'] == dateStr).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildCalendar(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) => _buildScheduleItem(filteredBookings[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 10),
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
              Text(isAvailable ? "Online - Visible on Map" : "Offline - Hidden from Map", 
                   style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: Colors.white,
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: focusedDate,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        onDaySelected: (selected, focused) {
          setState(() {
            selectedDate = selected;
            focusedDate = focused;
            _filterBookings();
          });
        },
        calendarFormat: CalendarFormat.week,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.3), shape: BoxShape.circle),
        ),
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
