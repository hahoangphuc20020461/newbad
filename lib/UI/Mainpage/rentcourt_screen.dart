
import 'package:flutter/material.dart';

class RentCourtPage extends StatefulWidget {
  const RentCourtPage({super.key});

  @override
  State<RentCourtPage> createState() => _RentCourtPageState();
}

class _RentCourtPageState extends State<RentCourtPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Sân đang thuê'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     onPressed: () {
        //       // Hành động khi nhấn vào icon
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        children: <Widget>[
          _buildOrderItem(context, 'Sân CTA', '17h30-19h30', 'Sân 1', '31/01/2024'),
          
          // Thêm các mục đơn hàng khác ở đây
        ],
      ),
      
    );
  }

  Widget _buildOrderItem(BuildContext context, String orderId, String itemTitle, String date, String repeatOrderText) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(orderId),
            subtitle: Text(date),
            trailing: Image.asset('assets/field.png'),
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CourtPage()));
              // Hành động khi nhấn vào mục đơn hàng
            },
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(itemTitle),
          ),
          
          // FlatButton(
          //   onPressed: () {
          //     // Hành động khi nhấn nút đặt lại
          //   },
          //   child: Text(repeatOrderText),
          //   color: Colors.orange,
          // ),
        ],
      ),
    );
  }
}