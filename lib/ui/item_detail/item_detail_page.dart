import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/data/model/product.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka URL

class ItemDetailPage extends StatelessWidget {
  final Product product;

  const ItemDetailPage({
    super.key,
    required this.product,
  });

  void _launchMap() async {
    const url =
        'https://www.google.com/maps?q=toko+roti+terdekat'; // URL Google Maps
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name ?? 'Tidak ada nama produk',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Colors.brown, // Warna background AppBar
        leading: BackButton(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Colors.brown[50], // Warna background halaman
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                product.imageUrl ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.name ?? 'Tidak ada nama produk',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${product.price ?? 'Tidak ada harga'}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.description ?? 'Tidak ada deskripsi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            const Spacer(), // Menambahkan spacer untuk mendorong tombol ke bawah
            ElevatedButton(
              onPressed: () {
                // Mengirimkan data item kembali ke halaman sebelumnya
                Navigator.pop(context, Product(
                  name: product.name,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  description: product.description,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Warna tombol
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                'Buy Now',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
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
              const Text(
                'Temukan Toko Roti Kami',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.map, color: Colors.white),
                onPressed: () {
                  if (Platform.isWindows) {
                    _launchMap; // Arahkan ke Google Maps
                  } else {
                    Navigator.pushNamed(context, '/map');
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
