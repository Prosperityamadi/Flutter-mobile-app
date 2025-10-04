import 'package:flutter/material.dart';
import 'package:spar/pages/splash_screen.dart';
import 'package:spar/pages/OTP/login.dart';
import 'package:spar/pages/OTP/otp.dart';
import 'package:spar/pages/Navigation/home_page.dart';

class RoutesManager {
  static const String splashScreen = '/splashScreen';
  static const String loginPage = '/loginPage';
  static const String otpPage = '/otpPage';
  static const String homePage = '/homePage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case loginPage:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case otpPage:
        final String phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpPage(
            phoneNumber: phoneNumber,
          ),
        );
      case homePage:
        return MaterialPageRoute(builder: (context) => HomePage());

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
