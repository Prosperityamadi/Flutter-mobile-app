import 'package:go_router/go_router.dart';
import 'package:spar/pages/Navigation/location_page.dart';
import 'package:spar/pages/splash_screen.dart';
import 'package:spar/pages/OTP/login.dart';
import 'package:spar/pages/OTP/otp.dart';
import 'package:spar/pages/Navigation/main_navigation.dart';

  GoRouter router = GoRouter(
    initialLocation: '/splashScreen',
    routes: [
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => const SplashScreen(),
      ),
      // This route shows your LoginPage. That's it.
      GoRoute(
        path: '/loginPage',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/otpPage/:phoneNumber',
        builder: (context, state) {
          final phoneNumber = state.pathParameters['phoneNumber']!;
          return OtpPage(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainNavigation(),
      ),
    ],
  );

