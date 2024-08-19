import 'package:flutter/material.dart';

class TransactionDetail extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  const TransactionDetail({
    super.key,
    required this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
      ),
      body: ListView.builder(
        itemCount: transactionData.length,
        itemBuilder: (context, index) {
          final itemName = transactionData.keys.toList()[index];
          final itemData = transactionData[itemName];
          return Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    itemData['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(itemName),
              subtitle: Text(itemData['quantity'].toString()),
              trailing: Text(itemData['price'].toString()),
            ),
          );
        },
      ),
    );
  }
}
