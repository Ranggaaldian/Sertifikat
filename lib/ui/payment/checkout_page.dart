import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/data/model/product.dart';
import 'package:sertifikasi_jmp_kp3/ui/payment/payment_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<Product> cartItems;

  const CheckoutPage({
    super.key,
    required this.cartItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Mengelompokkan item yang sama
  final Map<String, Map<String, dynamic>> _groupedItems = {};

  @override
  void initState() {
    super.initState();
    _groupItems();
  }

  void _groupItems() {
    _groupedItems.clear();
    for (var item in widget.cartItems) {
      final key = item.name;
      if (_groupedItems.containsKey(key)) {
        _groupedItems[key]!['quantity'] += 1;
      } else {
        _groupedItems[key!] = {
          'name': item.name,
          'price': item.price,
          'image': item.imageUrl,
          'quantity': 1
        };
      }
    }
  }

  void _removeItem(String itemName) {
    setState(() {
      for (var i = 0; i < widget.cartItems.length; i++) {
        if (widget.cartItems[i].name == itemName) {
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
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Colors.brown,
        leading: BackButton(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _groupedItems.length,
              itemBuilder: (context, index) {
                final item = _groupedItems.values.elementAt(index);
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text('${item['price']} x ${item['quantity']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
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
                          builder: (context) => PaymentPage(
                            groupedItems: _groupedItems,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Pembayaran',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
