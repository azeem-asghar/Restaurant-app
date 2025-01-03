import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> deleteuser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
      
        final credentials = EmailAuthProvider.credential(
          email: user.email!,
          password: 'user_password',
        );
        await user.reauthenticateWithCredential(credentials);

        
        await user.delete();
        await clearSharedPreferences();
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }


  Future<void> SignOut() async {
    try {
      await _auth.signOut();
      await clearSharedPreferences();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.remove('display_name');
  }
}