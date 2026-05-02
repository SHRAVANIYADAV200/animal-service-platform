import 'package:flutter/material.dart';
import '../services/session.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'consultation_detail_screen.dart';
import 'provider_schedule_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  State<ServiceProviderDashboard> createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProviderHomeTab(),
    const ProviderScheduleTab(),
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
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor), label: "Dashboard"),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event, color: AppTheme.primaryColor), label: "Schedule"),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map, color: AppTheme.primaryColor), label: "Map"),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: AppTheme.primaryColor), label: "Profile"),
        ],
      ),
    );
  }
}

class ProviderHomeTab extends StatefulWidget {
  const ProviderHomeTab({super.key});

  @override
  State<ProviderHomeTab> createState() => _ProviderHomeTabState();
}

class _ProviderHomeTabState extends State<ProviderHomeTab> {
  List bookings = [];
  Map stats = {"total": 0, "pending": 0, "accepted": 0, "rejected": 0};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final user = Session.currentUser;
    final email = user?['email'];
    final bData = email != null ? await ApiService.getProviderBookings(email) : await ApiService.getAllBookings();
    final sData = await ApiService.getBookingStats(email: email);
    
    if (mounted) {
      setState(() {
        bookings = bData;
        stats = sData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => loadData(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dashboard", style: Theme.of(context).textTheme.bodyMedium),
                    Text("Hello, ${user?['name']?.split(' ')[0] ?? 'Doctor'}", style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
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
                    // Stats Row
                    Row(
                      children: [
                        _statCard("Pending", stats['pending'].toString(), Colors.orange),
                        const SizedBox(width: 12),
                        _statCard("Accepted", stats['accepted'].toString(), Colors.green),
                        const SizedBox(width: 12),
                        _statCard("Completed", "0", Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text("Active Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : bookings.isEmpty
                            ? _emptyRequests()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bookings.length,
                                itemBuilder: (context, index) => _requestItem(bookings[index]),
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _requestItem(Map b) {
    bool isPending = b['status'] == "PENDING";
    return InkWell(
      onTap: isPending
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ConsultationDetailScreen(booking: b)),
              ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                  child: const Icon(Icons.person_outline, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b['farmerEmail'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(b['serviceType'], style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ),
                if (b['status'] == "ACCEPTED")
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
                else
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, color: AppTheme.primaryColor, size: 20),
                    onPressed: () => launchUrl(Uri.parse("tel:9999999999")),
                  ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _update(b['id'], "REJECTED"),
                      child: const Text("Decline", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _update(b['id'], "ACCEPTED"),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyRequests() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text("No requests today", style: TextStyle(color: Colors.grey.shade400)),
      ),
    );
  }

  void _update(int id, String status) async {
    final user = Session.currentUser;
    await ApiService.updateBookingStatus(id, status, providerEmail: user?['email']);
    loadData();
  }
}