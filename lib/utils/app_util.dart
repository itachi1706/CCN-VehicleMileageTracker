import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUtil {
  static void showSnackbarQuick(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  static Widget loadingScreen() => Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: AppUtil.centerLoadingCircle('Getting Data'),
      );

  static Widget centerLoadingCircle(String loadText) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(loadText),
          ],
        ),
      );

  static Widget loggedInUserScaffold(
    BuildContext context, {
    String title = "",
    Widget? body,
    List<Widget> additionalActions = const [],
    Widget? floatingActionButton,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
          ...additionalActions
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
