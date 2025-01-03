import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/service/database.dart';
import 'package:project/service/shared_pref.dart';
import 'package:project/widget/widget_support.dart';
import 'credit_card.dart';
import 'receipt.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, userName;
  int total = 0, amount2 = 0;

  Future<void> clearCart(String userId) async {
    try {
      CollectionReference cartCollection = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart");

      QuerySnapshot cartItems = await cartCollection.get();

      for (QueryDocumentSnapshot doc in cartItems.docs) {
        await doc.reference.delete();
      }

      setState(() {
        total = 0;
      });

      print("Cart cleared successfully!");
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    userName = await SharedPreferenceHelper().getUserName();

    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);

    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(child: Text("No items in the cart"));
          }
          total = 0;
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                total += int.parse(ds["Total"]);
                return Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 90,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text(ds["Quantity"])),
                          ),
                          SizedBox(width: 20.0),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                ds["ImageUrl"],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(width: 20.0),
                          Column(
                            children: [
                              Text(
                                ds["Name"],
                                style: Appwidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "\$" + ds["Total"],
                                style: Appwidget.semiBoldTextFeildStyle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Future<void> generateReceipt(String address) async {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String deliveryTime =
        DateFormat('HH:mm').format(DateTime.now().add(Duration(hours: 1)));

    Map<String, dynamic> receiptData = {
      "userName": userName,
      "totalPrice": total,
      "date": currentDate,
      "deliveryTime": deliveryTime,
      "address": address,
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("receipts")
        .add(receiptData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          userName: userName!,
          totalPrice: total,
          date: currentDate,
          deliveryTime: deliveryTime,
          address: address,
        ),
      ),
    );
  }

 Future<void> _showAddressDialog() async {
    TextEditingController addressController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          'Enter Address',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please provide your address to proceed.',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String address = addressController.text;
              if (address.isNotEmpty) {
                Navigator.of(context).pop();
                _navigateToCreditCardPage(address);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text('Proceed', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToCreditCardPage(String address) async {
    bool? success = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditCardPage(amount: total.toDouble()),
      ),
    );

    if (success == true) {
      await generateReceipt(address);
      await clearCart(id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: Appwidget.HeadlineTextFeildStyle(),
                    )))),
            SizedBox(
              height: 20.0,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: Appwidget.boldTextFeildStyle(),
                  ),
                  Text(
                    "\$" + total.toString(),
                    style: Appwidget.semiBoldTextFeildStyle(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                if (total > 1) {
                  await _showAddressDialog();
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Please add items to the cart!",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
