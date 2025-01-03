import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project/pages/contact.dart';
import 'home.dart';
import 'order.dart';
import 'profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late ContactPage contact;

  @override
  void initState() {
    homepage = const Home();
    order = const Order();
    profile = const Profile();
    contact = const ContactPage();
    pages = [homepage, order, contact, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SingleChildScrollView(
        child: CurvedNavigationBar(
            height: 65,
            backgroundColor: Colors.white,
            color: Colors.black,
            animationDuration: const Duration(seconds: 5),
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            items: const [
              Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.contact_mail_outlined,
                color: Colors.white,
              ),
              Icon(
                Icons.person_outline,
                color: Colors.white,
              )
            ]),
      ),
      body: pages[currentTabIndex],
    );
  }
}
