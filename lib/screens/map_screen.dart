import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng? currentPosition;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // 📍 GET LOCATION FUNCTION
  Future<void> getLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    // 🔍 Check GPS
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // 🔐 Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied");
      return;
    }

    // 📍 Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng newPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      currentPosition = newPosition;
    });

    // 🎯 Move camera to current location
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(newPosition, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Colors.green,
      ),

      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(

        // 🎮 Map controller
        onMapCreated: (controller) {
          mapController = controller;
        },

        initialCameraPosition: CameraPosition(
          target: currentPosition!,
          zoom: 15,
        ),

        // 📍 Marker (Current Location)
        markers: {
          Marker(
            markerId: const MarkerId("me"),
            position: currentPosition!,
            infoWindow: const InfoWindow(title: "My Location"),
          ),
        },

        // 🔵 Blue dot (live location)
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}