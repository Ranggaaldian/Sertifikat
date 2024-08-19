import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-7.0521, 110.4353),
        zoom: 15,
      ),
      markers: {
        const Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('currentLocation'),
          position: LatLng(-7.0521, 110.4353),
          infoWindow: InfoWindow(
            title: 'Lokasi Toko Roti',
          ),
        ),
      },
    );
  }
}
