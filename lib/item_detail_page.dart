import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka URL

class ItemDetailPage extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final String description;

  ItemDetailPage({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  void _launchMap() async {
    const url = 'https://www.google.com/maps?q=toko+roti+terdekat'; // URL Google Maps
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.brown, // Warna background AppBar
      ),
      backgroundColor: Colors.brown[50], // Warna background halaman
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Spacer(), // Menambahkan spacer untuk mendorong tombol ke bawah
            ElevatedButton(
              onPressed: () {
                // Mengirimkan data item kembali ke halaman sebelumnya
                Navigator.pop(context, {
                  'name': name,
                  'price': price,
                  'image': image,
                });
              },
              child: Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Warna tombol
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Temukan Toko Roti Kami',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white),
                onPressed: _launchMap, // Arahkan ke Google Maps
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        child: Icon(Icons.map),
        onPressed: _launchMap, // Arahkan ke Google Maps
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
