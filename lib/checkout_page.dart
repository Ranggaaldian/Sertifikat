import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Mengelompokkan item yang sama
  Map<String, Map<String, dynamic>> _groupedItems = {};

  @override
  void initState() {
    super.initState();
    _groupItems();
  }

  void _groupItems() {
    _groupedItems.clear();
    for (var item in widget.cartItems) {
      final key = item['name'];
      if (_groupedItems.containsKey(key)) {
        _groupedItems[key]!['quantity'] += 1;
      } else {
        _groupedItems[key] = {
          'name': item['name'],
          'price': item['price'],
          'image': item['image'],
          'quantity': 1
        };
      }
    }
  }

  void _removeItem(String itemName) {
    setState(() {
      for (var i = 0; i < widget.cartItems.length; i++) {
        if (widget.cartItems[i]['name'] == itemName) {
          widget.cartItems.removeAt(i);
          break;
        }
      }
      _groupItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _groupedItems.length,
              itemBuilder: (context, index) {
                final item = _groupedItems.values.elementAt(index);
                return ListTile(
                  leading: Image.network(item['image'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text('${item['price']} x ${item['quantity']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeItem(item['name']);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: widget.cartItems.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentPage(cartItems: widget.cartItems),
                        ),
                      );
                    },
              child: Text('Pembayaran'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  PaymentPage({required this.cartItems});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _currentAddress = 'Mengambil lokasi...';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = 'Layanan lokasi tidak diaktifkan.';
      });
      return;
    }

    // Memeriksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = 'Izin lokasi ditolak';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = 'Izin lokasi ditolak secara permanen';
      });
      return;
    }

    // Mendapatkan lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('address', _currentAddress);
    await prefs.setString('cartItems', widget.cartItems.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            Text('Alamat: $_currentAddress'),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await _saveData();
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: Text('Simpan dan Kembali'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }
}
