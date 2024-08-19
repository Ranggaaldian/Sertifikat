import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, Map<String, dynamic>> groupedItems;

  const PaymentPage({
    super.key,
    required this.groupedItems,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  bool isGpsServiceEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _currentAddress = 'Mengambil lokasi...';

  @override
  void initState() {
    _checkGps();
    _determinePosition();
    super.initState();
  }

  Future<void> _checkGps() async {
    isGpsServiceEnabled = await Geolocator.isLocationServiceEnabled();
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
      if (kDebugMode) print(e);
    }
  }

  Future<void> _saveData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() => isLoading = true);
    await firestore.collection('transactions').add({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _currentAddress,
      'cartItems': widget.groupedItems,
    });
    setState(() => isLoading = false);
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Payment',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Colors.brown,
            leading: BackButton(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                    ),
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) => value!.isEmpty
                        ? 'Nomor Telepon tidak boleh kosong'
                        : null,
                    decoration:
                        const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Text('Alamat: $_currentAddress'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menyimpan data?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _saveData();
                                  },
                                  child: const Text('Ya'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      // ignore: use_build_context_synchronously
                      // Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: Text(
                      'Simpan dan Kembali',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
