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
