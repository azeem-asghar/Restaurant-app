import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/feedback.dart';
import 'package:project/pages/contact.dart';
import 'package:project/service/database.dart';
import 'package:project/widget/widget_support.dart';
import 'order.dart' as projectOrder;
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecreame = false, salad = false, pizza = false, burger = false;
  Stream<QuerySnapshot>? fooditemStream;

  void loadItems(String category) async {
    fooditemStream = DatabaseMethods().getFoodItem(category);
    setState(() {});
  }

  @override
  void initState() {
    loadItems("Ice-cream");
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                          detail: ds["detail"],
                          name: ds["name"],
                          price: ds["price"],
                          image: ds["imageUrl"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                ds["imageUrl"],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              ds["name"],
                              style: Appwidget.semiBoldTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Fresh and Healthy",
                              style: Appwidget.LightTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "\$${ds["price"]}",
                              style: Appwidget.semiBoldTextFeildStyle(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90.0, 
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 84, 176, 204),
                    Color.fromARGB(255, 0, 128, 128),
                  ],
                  
                ),
                
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 50.0,
                left: 20.0,
              ),
             
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Welcome To Masalydar Bites",
                          style: Appwidget.boldTextFeildStyle().copyWith(
                            color: Colors.white, 
                          )),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
                            },
                            child: const Icon(
                              Icons.feedback_outlined,
                              color: Colors.white, 
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          
                         
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text("Delicious Food", style: Appwidget.HeadlineTextFeildStyle()),
                  Text("Discover and Get Great Food",
                      style: Appwidget.LightTextFeildStyle()),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      margin: const EdgeInsets.only(right: 20.0), child: showItem()),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Flexible(
                    child: Container(height: 300, child: allItems()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            icecreame = true;
            pizza = false;
            salad = false;
            burger = false;
            loadItems("Ice-cream");
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: icecreame ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset("images/ice-cream.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: icecreame ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecreame = false;
            pizza = true;
            salad = false;
            burger = false;
            loadItems("Pizza");
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset("images/pizza.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: pizza ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecreame = false;
            pizza = false;
            salad = false;
            burger = true;
            loadItems("Burger");
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: burger ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset("images/burger.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: burger ? Colors.white : Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            icecreame = false;
            pizza = false;
            salad = true;
            burger = false;
            loadItems("Salad");
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: salad ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(8),
              child: Image.asset("images/salad.png",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  color: salad ? Colors.white : Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
