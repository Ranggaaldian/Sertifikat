import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool? isLoading;
  bool? isLocationServiceEnabled;
  LocationPermission? locationPermission;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _checkGpsService();
  }

  Future<void> _checkGpsService() async {
    // Memeriksa apakah layanan lokasi diaktifkan
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!isLocationServiceEnabled!) {
    //   return;
    // }

    // Memeriksa izin lokasi
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return;
    }

    if (isLocationServiceEnabled! &&
        (locationPermission == LocationPermission.whileInUse ||
            locationPermission == LocationPermission.always)) {
      _determinePosition();
    }
  }

  Future<void> _determinePosition() async {
    // Mendapatkan lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLocationServiceEnabled != null &&
        (locationPermission == LocationPermission.whileInUse ||
            locationPermission == LocationPermission.always)) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 15,
        ),
        markers: {
          Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: const MarkerId('currentLocation'),
            position: currentLocation!,
            infoWindow: const InfoWindow(
              title: 'Lokasi Anda',
            ),
          ),
        },
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
