import 'package:flutter/material.dart';
import '../services/session.dart';
import '../services/api_service.dart';
import 'map_screen.dart';

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  State<ServiceProviderDashboard> createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {

  List bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final data = await ApiService.getAllBookings();

    setState(() {
      bookings = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MapScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔥 HEADER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${user?['name'] ?? ''}",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "Email: ${user?['email'] ?? ''}",
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 📥 REQUESTS
              const Text("Incoming Service Requests",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];

                  return Card(
                    color: b['status'] == "ACCEPTED"
                        ? Colors.green[50]
                        : b['status'] == "REJECTED"
                        ? Colors.red[50]
                        : Colors.white,
                    child: ListTile(
                      title: Text(b['serviceType']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b['farmerEmail']),
                          const SizedBox(height: 4),
                          Text(
                            b['status'] ?? "PENDING",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: b['status'] == "ACCEPTED"
                                  ? Colors.green
                                  : b['status'] == "REJECTED"
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      trailing: b['status'] == "PENDING"
                          ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // ❌ REJECT
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              await ApiService.updateStatus(b['id'], "REJECTED");
                              loadBookings();
                            },
                          ),

                          // ✅ ACCEPT
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              await ApiService.updateStatus(b['id'], "ACCEPTED");
                              loadBookings();
                            },
                          ),
                        ],
                      )
                          : Text(
                        b['status'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: b['status'] == "ACCEPTED"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}