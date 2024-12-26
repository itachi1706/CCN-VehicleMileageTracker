import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedInUserScaffold extends StatelessWidget {
  final Widget? body;
  final String title;
  final List<Widget> additionalActions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  const LoggedInUserScaffold({
    super.key,
    @required this.body,
    this.title = "",
    this.additionalActions = const [],
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...additionalActions,
          IconButton(
            tooltip: 'Logout',
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
