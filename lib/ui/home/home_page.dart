import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/data/model/product.dart';
import '../item_detail/item_detail_page.dart';
import '../payment/checkout_page.dart'; // Import halaman checkout
import '../buyer_data/buyer_data_page.dart'; // Import halaman data pembeli

class HomePage extends StatefulWidget {
  final String role;

  const HomePage({
    super.key,
    required this.role,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> productItems = [];
  List<Product> cartItems = [];

  @override
  void initState() {
    _fetchProduct();
    super.initState();
  }

  Future<void> _fetchProduct() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('products').get();
    final List<Product> fetchedProducts = [];

    for (final item in response.docs) {
      final product = Product.fromJson(item.data());
      fetchedProducts.add(product);
    }

    setState(() {
      productItems.addAll(fetchedProducts);
    });
  }

  void _addItemToCart(Product item) {
    setState(() {
      cartItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Roti dan Kue',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Colors.brown, // Warna background AppBar
        actions: [
          IconButton(
            icon: Badge(
              label: Text(
                cartItems.length.toString(),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(
                    cartItems: cartItems,
                  ), // Navigasi ke halaman checkout
                ),
              );
            },
          ),
          if (widget.role ==
              'admin') // Tampilkan ikon hanya jika role adalah admin
            IconButton(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BuyerDataPage(), // Navigasi ke halaman data pembeli
                  ),
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.brown[50], // Warna background halaman
      body: RefreshIndicator(
        onRefresh: () async {
          productItems.clear();
          await _fetchProduct();
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom
            crossAxisSpacing: 9.0, // Jarak horizontal antar item
            mainAxisSpacing: 9.0, // Jarak vertikal antar item
            childAspectRatio: 0.9, // Rasio lebar dan tinggi item
          ),
          itemCount: productItems.length,
          itemBuilder: (context, index) {
            final item = productItems[index];
            return GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailPage(
                      product: item,
                    ),
                  ),
                );
                if (result != null) {
                  _addItemToCart(
                    result,
                  ); // Tambahkan item ke cart jika ada hasil dari halaman detail
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 120, // Ukuran tetap untuk gambar
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10.0)),
                        image: DecorationImage(
                          image: NetworkImage(item.imageUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? 'Tidak ada nama',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${item.price?.toString() ?? 'Tidak ada harga'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
