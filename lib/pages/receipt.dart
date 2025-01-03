import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Receipt {
  final String userName;
  final int totalPrice;
  final String date;
  final String deliveryTime;
  final String address;

  Receipt({
    required this.userName,
    required this.totalPrice,
    required this.date,
    required this.deliveryTime,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "totalPrice": totalPrice,
      "date": date,
      "deliveryTime": deliveryTime,
      "address": address,
    };
  }

  static Future<void> generateReceipt(String userId, String userName, int totalPrice, String address) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String deliveryTime = DateFormat('HH:mm').format(DateTime.now().add(Duration(hours: 1)));

    Receipt receipt = Receipt(
      userName: userName,
      totalPrice: totalPrice,
      date: currentDate,
      deliveryTime: deliveryTime,
      address: address,
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("receipts")
        .add(receipt.toMap());
  }
}

class ReceiptPage extends StatelessWidget {
  final String userName;
  final int totalPrice;
  final String date;
  final String deliveryTime;
  final String address;

  const ReceiptPage({
    super.key,
    required this.userName,
    required this.totalPrice,
    required this.date,
    required this.deliveryTime,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        backgroundColor: Color.fromARGB(255, 84, 176, 204),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thank you for your order, $userName!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Order Details:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Total Price: \$${totalPrice.toString()}",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Date: $date",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Expected Delivery Time: $deliveryTime",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Delivery Address: $address",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 84, 176, 204),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
