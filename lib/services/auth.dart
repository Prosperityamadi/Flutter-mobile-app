import 'package:firebase_auth/firebase_auth.dart';
import 'package:spar/others/userdata.dart' as UserModel;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This is the ONLY version of the function you should have.
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
    print("DEBUG: Auth state changes: ${_auth.authStateChanges()}");
        return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      print("DEBUG: Attempting Firebase anonymous sign-in...");
      UserCredential result = await _auth.signInAnonymously();
      User? firebaseUser = result.user;
      print("DEBUG: Anonymous sign-in successful! User: ${firebaseUser?.uid}");
      // The stream will automatically handle creating the rich user object.
      // We just need to return the firebase user.
      return firebaseUser;
    } catch (e) {
      print("ERROR in signInAnon: ${e.toString()}");
      // ... your detailed error printing
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_phone_number');
      // ---------------------------------------------
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
