import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

import 'doctor_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentPosition;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  List providers = [];
  bool isLoading = true;
  int selectedProviderIndex = -1;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    await getLocation();
    await _loadProviders();
  }

  Future<void> _loadProviders() async {
    final data = await ApiService.getAllProviders();
    setState(() {
      providers = data;
      _updateMarkers();
      isLoading = false;
    });
  }

  void _updateMarkers() {
    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};
    
    if (currentPosition != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("me"),
          position: currentPosition!,
          infoWindow: const InfoWindow(title: "My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    for (int i = 0; i < providers.length; i++) {
      var p = providers[i];
      if (p['latitude'] != null && p['longitude'] != null && (p['isAvailable'] ?? true)) {
        final pos = LatLng(p['latitude'], p['longitude']);
        
        newMarkers.add(
          Marker(
            markerId: MarkerId("provider_${p['id']}"),
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              selectedProviderIndex == i ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen
            ),
            onTap: () {
              setState(() => selectedProviderIndex = i);
              _pageController.animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
            },
            infoWindow: InfoWindow(
              title: p['name'],
              snippet: p['specialization'],
            ),
          ),
        );

        newCircles.add(
          Circle(
            circleId: CircleId("area_${p['id']}"),
            center: pos,
            radius: 500,
            fillColor: Colors.green.withOpacity(0.1),
            strokeColor: Colors.green.withOpacity(0.3),
            strokeWidth: 1,
          ),
        );
      }
    }

    setState(() {
      markers = newMarkers;
      circles = newCircles;
    });
  }

  Future<void> getLocation() async {
    const fallbackLocation = LatLng(18.5204, 73.8567);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => currentPosition = fallbackLocation);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => currentPosition = fallbackLocation);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      setState(() => currentPosition = newPosition);
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 13));
    } catch (e) {
      setState(() => currentPosition = fallbackLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(target: currentPosition!, zoom: 13),
                  markers: markers,
                  circles: circles,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                ),
          
          // Custom Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Search Bar
          Positioned(
            top: 50,
            left: 70,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search nearby vets...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),

          // Provider Cards List
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: providers.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => _buildProviderCard(providers[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(Map p, int index) {
    bool isSelected = selectedProviderIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedProviderIndex = index);
        if (p['latitude'] != null) {
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(p['latitude'], p['longitude']), 15)
          );
        }
        _updateMarkers();
      },
      onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: p))),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 2) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(p['specialization'] ?? "Vet Specialist", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(p['avgRating']?.toString() ?? "0.0", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text("(${p['distance'] ?? '0.8 km'})", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DoctorDetailScreen(doctor: p))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 36),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("View & Book", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}