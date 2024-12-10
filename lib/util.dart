
import 'package:flutter/material.dart';

class Util {
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
    body: Util.centerLoadingCircle('Getting Data'),
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
}
