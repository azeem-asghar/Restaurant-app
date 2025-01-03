import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/service/shared_pref.dart';
import 'package:project/widget/widget_support.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();
  String userId = "";
  double rating = 3.0;

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

  submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> feedbackData = {
        "userId": userId,
        "feedback": feedbackController.text,
        "rating": rating,
        "timestamp": FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection("feedback").add(feedbackData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Thank you for your feedback!",
          style: TextStyle(fontSize: 18.0),
        ),
        backgroundColor: Colors.green,
      ));
      feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
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
                  "We value your feedback!",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                     color: const Color.fromARGB(255, 84, 176, 204),
                  ),
                ),
                const SizedBox(height: 16.0),
                RatingBar.builder(
                  initialRating: 3.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Share your thoughts...",
                    hintStyle:
                        const TextStyle(fontSize: 16.0, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                           color: const Color.fromARGB(255, 84, 176, 204),
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 84, 176, 204),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Submit Feedback",
                      style: TextStyle(
                        color: Colors.white,
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
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
