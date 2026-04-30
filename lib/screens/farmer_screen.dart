import 'package:flutter/material.dart';
import '../services/session.dart';
import '../services/api_service.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {

  List bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final user = Session.currentUser;

    final data = await ApiService.getFarmerBookings(user!['email']);

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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Bookings"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome, ${user?['name'] ?? ''}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Email: ${user?['email'] ?? ''}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.notifications, color: Colors.green),
                ],
              ),

              const SizedBox(height: 10),

              // 🔍 SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText: "Search services...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🟩 SERVICES GRID
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: [

                  buildService("Vet Doctor", Icons.pets),
                  buildService("Vaccination", Icons.vaccines),
                  buildService("Emergency", Icons.emergency),
                  buildService("Animal Care", Icons.agriculture),
                  buildService("Nearby", Icons.location_searching),
                  buildService("Bookings", Icons.calendar_month),

                ],
              ),

              const SizedBox(height: 20),

              // 📅 BOOKINGS
              const Text("Recent Bookings",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];

                  return Card(
                    child: ListTile(
                      title: Text(b['serviceType']),
                      subtitle: Text(b['farmerEmail']),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            b['status'],
                            style: TextStyle(
                              color: b['status'] == "PENDING"
                                  ? Colors.orange
                                  : b['status'] == "ACCEPTED"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),

                          // 👇 SHOW TIME IF AVAILABLE
                          if (b['appointmentTime'] != null)
                            Text(
                              b['appointmentTime'],
                              style: TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SERVICE FUNCTION
  Widget buildService(String title, IconData icon) {
    return GestureDetector(
      onTap: () async {
        final user = Session.currentUser;

        await ApiService.createBooking(
          user!['email'],
          title,
        );

        loadBookings(); // 🔥 refresh

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title booked")),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.green),
            const SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}