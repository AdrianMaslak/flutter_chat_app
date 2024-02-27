import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> loadUserData() async {
    String userId = _auth.currentUser!.uid; // Assuming the user is logged in
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> saveUsername(String username) async {
    String userId = _auth.currentUser!.uid; // Assuming the user is logged in
    await _firestore.collection('Users').doc(userId).set(
        {
          'username': username,
        },
        SetOptions(
            merge:
                true)); // Merge true to update the document without overwriting other fields
  }

  Future<String?> getUsernameByID(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        return data?['username'] as String?;
      }
      return null;
    } catch (e) {
      print("error fetching username: $e");
      return null;
    }
  }
}
