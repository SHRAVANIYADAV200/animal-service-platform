import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animal1/l10n/app_localizations.dart';
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initMap();
    _timer = Timer.periodic(const Duration(seconds: 5), (t) => _loadProviders(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initMap() async {
    await getLocation();
    await _loadProviders();
  }

  Future<void> _loadProviders({bool silent = false}) async {
    if (!silent) setState(() => isLoading = true);
    final data = await ApiService.getAllProviders();
    if (mounted) {
      setState(() {
        providers = data;
        _updateMarkers();
        isLoading = false;
      });
    }
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchNearbyVets,
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),

          // Fixed Vertical List for Nearby Doctors
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.searchNearbyVets,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${providers.length} Vets",
                            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: providers.length,
                      itemBuilder: (context, index) => _buildProviderCard(providers[index], index),
                    ),
                  ),
                ],
              ),
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 2) : Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.person, size: 30, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(p['specialization'] ?? AppLocalizations.of(context)!.veterinarySpecialist, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text("${p['avgRating']?.toString() ?? "0.0"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text("Distance: ${p['distance'] ?? '0.8 km'}", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
