import 'package:flutter/material.dart';
import 'package:spar/pages/Navigation/location_page.dart';
import 'package:spar/pages/Navigation/main_navigation.dart';
import 'package:spar/pages/splash_screen.dart';
import 'package:spar/pages/OTP/login.dart';
import 'package:spar/pages/OTP/otp.dart';

class RoutesManager {
  static const String splashScreen = '/splashScreen';
  static const String loginPage = '/loginPage';
  static const String otpPage = '/otpPage';
  static const String homePage = '/homePage';
  static const String location = '/location';

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
        return MaterialPageRoute(builder: (context) => MainNavigation());
      case location:
        return MaterialPageRoute(builder: (context) => LocationPage(),);
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
