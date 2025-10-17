
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spar/others/userdata.dart' as UserModel;
import 'package:spar/pages/OTP/login.dart';
import 'package:spar/pages/Navigation/main_navigation.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Keep track of the last known user state to prevent multiple navigations
  bool _isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel.User?>(context);

    // Check if the auth state has changed
    final bool wasUserLoggedIn = _isUserLoggedIn;
    _isUserLoggedIn = user != null;

    // If the state changed from logged-out to logged-in
    if (!wasUserLoggedIn && _isUserLoggedIn) {
      // Use a post-frame callback to ensure the build is complete before navigating
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation()),
            (route) => false,
          );
        }
      });
    }
    return const LoginPage(); // Assuming login_page.dart has a LoginPage widget
  }
}
