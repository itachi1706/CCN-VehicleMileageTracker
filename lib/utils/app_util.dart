import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUtil {
  static void showSnackbarQuick(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  static String formatDurationWords(int durationMillis) {
    if (durationMillis < 0) {
      throw ArgumentError("Duration must be non-negative");
    }

    int seconds = durationMillis ~/ 1000;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int days = hours ~/ 24;

    seconds %= 60;
    minutes %= 60;
    hours %= 24;

    List<String> parts = [];

    if (days > 0) {
      parts.add("$days day${days > 1 ? 's' : ''}");
    }
    if (hours > 0) {
      parts.add("$hours hour${hours > 1 ? 's' : ''}");
    }
    if (minutes > 0) {
      parts.add("$minutes minute${minutes > 1 ? 's' : ''}");
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add("$seconds second${seconds > 1 ? 's' : ''}");
    }

    return parts.join(", ");
  }

  static void showComingSoonSnackbar(BuildContext context) {
    AppUtil.showSnackbarQuick(
      context,
      'Feature Coming Soon!',
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
    FloatingActionButtonLocation floatingActionButtonLocation =
        FloatingActionButtonLocation.endFloat,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...additionalActions,
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: body,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
    );
  }
}

