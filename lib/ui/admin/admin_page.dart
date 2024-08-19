import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/data/model/transaction_history.dart';
import 'package:sertifikasi_jmp_kp3/ui/transaction_detail/transaction_detail.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<TransactionHistory> transactions = [];

  @override
  void initState() {
    _fetchTransactions();
    super.initState();
  }

  Future<void> _fetchTransactions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('transactions').get();
    final List<TransactionHistory> fetchedTransactions = [];

    for (final item in response.docs) {
      final transaction = TransactionHistory.fromJson(item.data());
      fetchedTransactions.add(transaction);
    }

    setState(() {
      transactions.addAll(fetchedTransactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth.signOut().then(
                            (value) {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          );
                        },
                        child: const Text('Ya'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tidak'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return InkWell(
            onTap: () {
              if (transaction.items != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetail(
                      transactionData: transaction.items!,
                    ),
                  ),
                );
              }
            },
            child: Card(
              child: ListTile(
                title: Text(
                  transaction.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nomor Telepon : ${transaction.phone ?? ''}'),
                    Text(
                        'Jenis Pesanan : ${transaction.items?.length.toString() ?? ''}'),
                    Text('Alamat : ${transaction.address ?? ''}'),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_rounded,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
