import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

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
    
    // Add current location marker
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

    // Add provider markers and highlight circles
    for (var p in providers) {
      if (p['latitude'] != null && p['longitude'] != null) {
        final pos = LatLng(p['latitude'], p['longitude']);
        
        // Marker
        newMarkers.add(
          Marker(
            markerId: MarkerId("provider_${p['id']}"),
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(
              title: p['name'],
              snippet: "${p['specialization'] ?? 'Vet'} - ${p['clinicName'] ?? 'Clinic'}",
            ),
          ),
        );

        // Highlight Circle (Service Area)
        newCircles.add(
          Circle(
            circleId: CircleId("area_${p['id']}"),
            center: pos,
            radius: 500, // 500 meters highlight
            fillColor: Colors.green.withOpacity(0.15),
            strokeColor: Colors.green.withOpacity(0.5),
            strokeWidth: 2,
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
    const fallbackLocation = LatLng(18.5204, 73.8567); // Pune Central
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

      if (permission == LocationPermission.deniedForever) {
        setState(() => currentPosition = fallbackLocation);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        currentPosition = newPosition;
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPosition, 13),
      );
    } catch (e) {
      debugPrint("Location error: $e");
      setState(() {
        currentPosition = fallbackLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Vets & Services"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProviders,
          ),
        ],
      ),
      body: Stack(
        children: [
          currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 13,
                  ),
                  markers: markers,
                  circles: circles,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
          if (isLoading)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: 12),
                      const Text("Finding nearby vets..."),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}