import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/service/shared_pref.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  _loadUserId() async {
    String? id = await SharedPreferenceHelper().getUserId();
    setState(() {
      userId = id ?? "";
    });
  }

  submitContactForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> contactData = {
        "userId": userId,
        "name": nameController.text,
        "email": emailController.text,
        "message": messageController.text,
        "timestamp": FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection("contact_us").add(contactData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Thank you for contacting us!",
          style: TextStyle(fontSize: 18.0),
        ),
        backgroundColor: Colors.green,
      ));
      nameController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 84, 176, 204),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "We'd love to hear from you!",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 84, 176, 204),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Your Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 84, 176, 204),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 84, 176, 204),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Your Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 84, 176, 204),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: submitContactForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 84, 176, 204),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Divider(),
                const SizedBox(height: 20.0),
                const Text(
                  "Our Address",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 84, 176, 204),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "6th Road, Sector 6, Islamabad, Pakistan",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 84, 176, 204),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "+92 123 4567890",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
