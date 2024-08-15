import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerDataPage extends StatefulWidget {
  @override
  _BuyerDataPageState createState() => _BuyerDataPageState();
}

class _BuyerDataPageState extends State<BuyerDataPage> {
  String? buyerName;
  String? buyerPhone;
  String? buyerAddress;

  @override
  void initState() {
    super.initState();
    _loadBuyerData();
  }

  Future<void> _loadBuyerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      buyerName = prefs.getString('buyerName');
      buyerPhone = prefs.getString('buyerPhone');
      buyerAddress = prefs.getString('buyerAddress');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pembeli'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: $buyerName"),
            SizedBox(height: 8),
            Text("Nomor Telepon: $buyerPhone"),
            SizedBox(height: 8),
            Text("Alamat: $buyerAddress"),
          ],
        ),
      ),
    );
  }
}
