import 'package:flutter/material.dart';
import 'package:spar/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:spar/routes/routes2.0.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      // This sets up a hybrid navigation system.
      // 1. `MaterialApp.router` with `AppRouter` (GoRouter) manages the primary app navigation
      // (e.g., handling stack resets, deep linking, and the main app shell).
      // 2. The nested `MaterialApp` in the `builder` is a compatibility layer. Its sole purpose
      // is to intercept and handle legacy Navigator 1.0 `pushNamed` calls via the old `RoutesManager`,
      // allowing the self-contained authentication flow (Login -> OTP) to function.
    return MaterialApp.router(
      title: 'Dennis Pizza',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MaterialApp(
          title: 'Dennis Pizza',
          onGenerateRoute: RoutesManager.generateRoute,
          home: child,
        );
      },
    );
  }
}
