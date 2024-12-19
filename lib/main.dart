import 'package:ccn_vehicle_mileage_tracker_basic/routes/add_new_mileage.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/routes/home.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/routes/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: DefaultFirebaseOptions.webClientId),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
        '/add-mileage': (context) => AddNewMileageScreen(),
      },
    );
  }
}
