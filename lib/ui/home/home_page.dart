import 'package:flutter/material.dart';
import '../item_detail/item_detail_page.dart';
import '../payment/checkout_page.dart'; // Import halaman checkout
import '../buyer_data/buyer_data_page.dart'; // Import halaman data pembeli

class HomePage extends StatefulWidget {
  final String role; // Tambahkan parameter role

  HomePage({required this.role}); // Tambahkan parameter role di constructor

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> items = [
    {
      'name': 'Croissant',
      'price': 'Rp 25.000',
      'image':
          'https://cdn.pixabay.com/photo/2022/11/08/05/06/bread-7577706_1280.jpg',
      'description':
          'Croissant adalah jenis pastry yang sangat populer, dikenal karena bentuknya yang unik menyerupai bulan sabit dan teksturnya yang berlapis-lapis. Kue ini memiliki rasa gurih yang khas, berasal dari kombinasi mentega yang kaya dan adonan yang berfermentasi. Croissant merupakan makanan khas dari Perancis. Croissant tersedia dalam berbagai varian, mulai dari yang polos hingga yang diisi dengan cokelat, keju, almond, atau isian lainnya. Croissant bisa disantap begitu saja atau dengan selai, mentega, atau dihangatkan terlebih dahulu.'
    },
    {
      'name': 'Bagel',
      'price': 'Rp 30.000',
      'image': 'https://images5.alphacoders.com/817/817120.jpg',
      'description':
          'Bagel adalah roti yang berbentuk cincin, biasanya berukuran sekepal tangan. Asalnya dari komunitas Yahudi di Polandia, bagel terbuat dari adonan tepung terigu, air, garam, dan ragi yang direbus sebentar dalam air sebelum dipanggang. Proses perebusan inilah yang memberikan tekstur bagel yang khas, yaitu kenyal di dalam dan sedikit renyah di luar. Bagel Terbuat dari berbagai jenis tepung, seperti gandum utuh atau rye, sehingga memberikan rasa dan tekstur yang berbeda-beda.'
    },
    {
      'name': 'Roti Buaya',
      'price': 'Rp 70.000',
      'image':
          'https://img.okezone.com/content/2023/06/21/298/2834766/hut-ke-496-dki-jakarta-sejarah-dan-asal-usul-roti-buaya-makanan-ikon-masyarakat-betawi-iwJyA5U2H9.jpg',
      'description':
          'Roti buaya adalah hidangan khas Betawi yang memiliki nilai sejarah dan budaya yang sangat tinggi. Roti ini bukan sekadar makanan biasa, melainkan simbol kesetiaan dalam pernikahan adat Betawi. Roti buaya memiliki rasa manis dan tekstur yang lembut.'
    },
    {
      'name': 'lapis Legit',
      'price': 'Rp 50.000',
      'image':
          'https://cdn0-production-images-kly.akamaized.net/PCgSaocrJIXkH7-WMTT4NBwZ88c=/1138x1366:2752x2276/1200x675/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/3910916/original/053624900_1642759761-Anns_Bakehouse_430312.jpg',
      'description': 'Kue dengan isi keju yang creamy.'
    },
    {
      'name': 'Cheese Cake',
      'price': 'Rp 35.000',
      'image': 'https://images7.alphacoders.com/132/1324790.png',
      'description':
          'Cheesecake adalah jenis kue atau puding yang dibuat dengan bahan dasar keju, baik itu keju krim (cream cheese) atau keju ricotta. Teksturnya yang lembut dan creamy, serta rasanya yang manis dan sedikit asam.'
    },
    {
      'name': 'Brownies',
      'price': 'Rp 25.000',
      'image':
          'https://img.freepik.com/premium-photo/fudgy-chocolate-brownies-background_872147-6096.jpg',
      'description':
          'Brownies adalah kue cokelat yang memiliki tekstur padat dan rasa yang kaya. Kue ini sangat populer dan sering dijadikan sebagai camilan atau dessert. Tekstur brownies bisa bervariasi, ada yang fudgy (lembut dan kenyal), cakey (seperti kue bolu), atau chewy (kenyal).'
    },
    {
      'name': 'Baguette',
      'price': 'Rp 17.000',
      'image':
          'https://cdn.pixabay.com/photo/2022/11/21/04/53/bread-7605920_640.jpg',
      'description':
          'Baguette adalah roti panjang dan tipis yang berasal dari Prancis. Roti ini memiliki tekstur yang renyah di bagian luar dan lembut di bagian dalam, serta aroma yang khas. Baguette sering digunakan sebagai teman makan, baik untuk sarapan, makan siang, maupun makan malam.'
    },
    {
      'name': 'Pain de Campagne',
      'price': 'Rp 40.000',
      'image':
          'https://img.cuisineaz.com/1024x768/2013/12/20/i9204-recette-de-pain-de-campagne.jpeg',
      'description':
          'Pain de Campagne atau yang sering disebut "roti desa Prancis" adalah jenis roti yang sangat populer di Prancis. Roti ini memiliki ciri khas rasa asam yang sedikit tajam dan tekstur yang padat namun lembut. Tekstur roti ini padat namun lembut, dengan kulit luar yang renyah. Bagian dalamnya seringkali terdapat lubang-lubang kecil yang terbentuk akibat proses fermentasi.'
    },
  ];

  List<Map<String, dynamic>> cartItems =
      []; // State untuk menampung item yang dibeli

  void _addItemToCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.add(item); // Menambah item ke keranjang belanja
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
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom
          crossAxisSpacing: 9.0, // Jarak horizontal antar item
          mainAxisSpacing: 9.0, // Jarak vertikal antar item
          childAspectRatio: 0.8, // Rasio lebar dan tinggi item
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(
                    name: item['name']!,
                    price: item['price']!,
                    image: item['image']!,
                    description: item['description']!,
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
                        image: NetworkImage(item['image']!),
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
                          item['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['price']!,
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
    );
  }
}
