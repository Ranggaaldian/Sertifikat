import 'package:flutter/material.dart';
import 'location_service.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String location = 'Menunggu lokasi...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    try {
      final position = await LocationService().getCurrentLocation();
      setState(() {
        location = 'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        location = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Saya'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Text(
          location,
          style: TextStyle(fontSize: 18, color: Colors.brown[800]),
        ),
      ),
    );
  }
}
