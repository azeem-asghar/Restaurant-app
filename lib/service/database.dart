import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addItemDetail(
      Map<String, dynamic> itemInfoMap, String collectionName) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .add(itemInfoMap);
  }

  Stream<QuerySnapshot> getFoodItem(String collectionName) {
    return FirebaseFirestore.instance.collection(collectionName).snapshots();
  }

  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("cart")
        .add(userInfoMap);
  }

  Stream<QuerySnapshot> getFoodCart(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("cart")
        .snapshots();
  }

  UpdateUserWallet(String id,String amount) async {
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(id).update({"Wallet":amount});
    
  }
}
