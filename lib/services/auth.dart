import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spar/others/userdata.dart' as UserModel;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Convert Firebase User to custom User model
  Future<UserModel.User?> _userFromFirebaseUser(User? user) async {
    if (user == null) {
      return null;
    }

    // Load the phone number from persistent storage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? phoneNumber = prefs.getString('last_phone_number');

    // Create the user object with the phone number
    return UserModel.User(
      uid: user.uid,
      phoneNumber: phoneNumber,
    );
  }

  // Auth change user stream
  Stream<UserModel.User?> get user {
    print("DEBUG: Getting auth state changes...");
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Sign in anonymously and save to Firestore
  Future signInAnon(String phoneNumber) async {
    try {
      print("DEBUG: Attempting Firebase anonymous sign-in...");
      UserCredential result = await _auth.signInAnonymously();
      User? firebaseUser = result.user;
      print("DEBUG: Anonymous sign-in successful! User: ${firebaseUser?.uid}");

      if (firebaseUser != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'isAnonymous': true,
        });

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_phone_number', phoneNumber);
        await prefs.setString('phoneNumber', phoneNumber);

        // Update UserData
        UserModel.UserData.phoneNumber = phoneNumber;

        print("DEBUG: User data saved to Firestore");
      }

      return firebaseUser;
    } catch (e) {
      print("ERROR in signInAnon: ${e.toString()}");
      return null;
    }
  }

  // Check if phone number already exists
  Future<String?> getUserIdByPhone(String phoneNumber) async {
    try {
      print("DEBUG: Checking if phone number exists: $phoneNumber");

      final querySnapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        print("DEBUG: Found existing user: $userId");
        return userId;
      }

      print("DEBUG: No existing user found");
      return null;
    } catch (e) {
      print("ERROR in getUserIdByPhone: ${e.toString()}");
      return null;
    }
  }

  // Sign in existing user (for returning users)
  Future<User?> signInExistingUser(String userId) async {
    try {
      print("DEBUG: Signing in existing user: $userId");

      // Sign in anonymously first
      UserCredential result = await _auth.signInAnonymously();
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        // Update last login time
        await _firestore.collection('users').doc(userId).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });

        print("DEBUG: Existing user signed in successfully");
      }

      return firebaseUser;
    } catch (e) {
      print("ERROR in signInExistingUser: ${e.toString()}");
      return null;
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("ERROR in getUserData: ${e.toString()}");
      return null;
    }
  }

  // Update user profile (name and profile image)
  Future<bool> updateUserProfile({
    required String uid,
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      Map<String, dynamic> updateData = {};

      if (name != null) {
        updateData['name'] = name;
        UserModel.UserData.userName = name;
      }

      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
        print("DEBUG: User profile updated successfully");
        return true;
      }

      return false;
    } catch (e) {
      print("ERROR in updateUserProfile: ${e.toString()}");
      return false;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_phone_number');
      await prefs.remove('phoneNumber');

      // Clear UserData
      UserModel.UserData.phoneNumber = null;
      UserModel.UserData.userName = null;

      return await _auth.signOut();
    } catch (e) {
      print("ERROR in signOut: ${e.toString()}");
      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}