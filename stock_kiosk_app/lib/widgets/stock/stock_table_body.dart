// material imports
import 'package:flutter/material.dart';
//internal widget imports
import 'package:stock_kiosk_app/widgets/stock/table_cell_widgets.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';

Widget stockTable() {
  //returns the stock table body widget
  return StreamBuilder(
    //listen to firestore collection 'items' for real-time updates of stock data
    stream: FirebaseFirestore.instance
        .collection('items')
        .orderBy('name')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        //show loading indicator while waiting for data
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //show message if no data available
        return Text(
          'No items available',
          style: TextStyle(color: Colors.white),
        );
      }

      final items = snapshot.data!.docs; //get list of item documents

      return ListView.builder(
        //build list view of stock items
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index].data();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                // build table row for each item (using tableCell widget for each cell)
                tableCell(item['name'] ?? '', flex: 3, align: TextAlign.left),
                tableCell(item['price'].toString()),
                tableCell(item['change'].toString()),
                const SizedBox(width: 48),
                tableCell(item['high'].toString()),
                tableCell(item['low'].toString()),
                tableCell(item['mv'] ?? ''),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget miniStockTable() {
  //returns the stock table body widget
  return StreamBuilder(
    //listen to firestore collection 'items' for real-time updates of stock data
    stream: FirebaseFirestore.instance
        .collection('items')
        .orderBy('name')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        //show loading indicator while waiting for data
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //show message if no data available
        return Text(
          'No items available',
          style: TextStyle(color: Colors.white),
        );
      }

      final items = snapshot.data!.docs; //get list of item documents

      return ListView.builder(
        //build list view of stock items
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index].data();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                // build table row for each item (using tableCell widget for each cell)
                tableCell(item['name'] ?? '', flex: 3, align: TextAlign.left),
                tableCell(item['price'].toString()),
                tableCell(item['change'].toString()),
              ],
            ),
          );
        },
      );
    },
  );
}
