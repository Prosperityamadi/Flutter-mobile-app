import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:spar/firebase_options.dart';
import 'package:spar/routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spar/services/auth.dart';
import 'package:spar/others/userdata.dart' as UserModel;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel.User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Dennis Pizza',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splashscreen',
        onGenerateRoute: RoutesManager.generateRoute,
      ),
    );
  }
}