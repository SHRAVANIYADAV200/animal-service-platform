import 'package:flutter/material.dart';
import '../services/session.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'map_screen.dart';
import 'provider_list_screen.dart';
import 'vaccination_screen.dart';
import 'profile_screen.dart';
import 'pharmacy_screen.dart';
import 'consultation_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FarmerHomeTab(),
    const ProviderListScreen(),
    const MapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: AppTheme.primaryColor.withOpacity(0.1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppTheme.primaryColor), label: "Home"),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: AppTheme.primaryColor), label: "Doctors"),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map, color: AppTheme.primaryColor), label: "Map"),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppTheme.primaryColor), label: "Profile"),
        ],
      ),
    );
  }
}

class FarmerHomeTab extends StatefulWidget {
  const FarmerHomeTab({super.key});

  @override
  State<FarmerHomeTab> createState() => _FarmerHomeTabState();
}

class _FarmerHomeTabState extends State<FarmerHomeTab> {
  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final user = Session.currentUser;
    if (user != null) {
      final data = await ApiService.getFarmerBookings(user['email']);
      if (mounted) {
        setState(() {
          bookings = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => loadBookings(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome back,", style: Theme.of(context).textTheme.bodyMedium),
                        Text(user?['name'] ?? 'Farmer', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: const Icon(Icons.person, color: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade400),
                          const SizedBox(width: 12),
                          Text("Search for doctors, services...", style: TextStyle(color: Colors.grey.shade400)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text("Our Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildQuickAction(context, "Consultation", Icons.medical_services, Colors.blue),
                        _buildQuickAction(context, "Vaccination", Icons.vaccines, Colors.orange),
                        _buildQuickAction(context, "Emergency", Icons.emergency, Colors.red),
                        _buildQuickAction(context, "Pharmacy", Icons.local_pharmacy, Colors.teal),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Recent Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(onPressed: () {}, child: const Text("View All")),
                      ],
                    ),
                    const SizedBox(height: 8),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : bookings.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bookings.length > 3 ? 3 : bookings.length,
                                itemBuilder: (context, index) => _buildAppointmentCard(context, bookings[index]),
                              ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (title == "Vaccination") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const VaccinationScreen()));
          } else if (title == "Pharmacy") {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()));
          } else if (title == "Emergency") {
            _showEmergencySheet(context);
          } else {
            _handleServiceBooking(title);
          }
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map b) {
    Color statusColor = Colors.orange;
    if (b['status'] == "ACCEPTED") statusColor = Colors.green;
    if (b['status'] == "REJECTED") statusColor = Colors.red;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ConsultationDetailScreen(booking: b)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b['serviceType'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(b['appointmentTime'] ?? "Schedule Pending", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(b['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Icon(Icons.calendar_month_outlined, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("No active appointments", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  void _showEmergencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Emergency Contacts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 8),
            const Text("Immediate help for your animals", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _emergencyItem("Vet Emergency Helpline", "1800-VET-HELP", Icons.phone),
            const SizedBox(height: 12),
            _emergencyItem("District Veterinary Hospital", "011-2345-6789", Icons.local_hospital),
            const SizedBox(height: 12),
            _emergencyItem("Mobile Vet Clinic", "011-9876-5432", Icons.airport_shuttle),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _emergencyItem(String title, String phone, IconData icon) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse("tel:$phone")),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(phone, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _handleServiceBooking(String service) async {
    final user = Session.currentUser;
    await ApiService.createBooking(user!['email'], service);
    loadBookings();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$service booking request sent!"), behavior: SnackBarBehavior.floating),
    );
  }
}