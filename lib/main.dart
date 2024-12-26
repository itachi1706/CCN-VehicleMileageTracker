import 'package:ccn_vehicle_mileage_tracker_basic/constants/creation_mode.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/routes/add_new_mileage.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/routes/home.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/routes/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: DefaultFirebaseOptions.webClientId),
  ]);
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
  redirect: (context, state) =>
      FirebaseAuth.instance.currentUser == null ? '/login' : null,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
        path: '/add-mileage',
        builder: (context, state) => AddNewMileageScreen()),
    GoRoute(
        path: '/edit-mileage/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AddNewMileageScreen(
            mode: CreationMode.edit,
            currentRecord: id,
          );
        }),
    GoRoute(
        path: '/continue-last-record',
        builder: (context, state) =>
            AddNewMileageScreen(mode: CreationMode.lastRecord)),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
