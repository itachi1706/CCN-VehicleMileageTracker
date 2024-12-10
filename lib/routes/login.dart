import 'package:ccn_vehicle_mileage_tracker_basic/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginRoute extends StatelessWidget {
  void _signInWithTest(BuildContext context) async {
    Util.showSnackbarQuick(context, 'Signing in with test account...');
    try {
      var credentials = await _auth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'test123',
      );
        _finishLoggedInFlow(context, credentials.user);
    } on FirebaseAuthException catch (_, e) {
      Util.showSnackbarQuick(context, 'Error signing in with test account');
      debugPrint('Error signing in with test account: $e');
    }
  }

  void _finishLoggedInFlow(BuildContext context, User? user) {
    Util.showSnackbarQuick(context, 'Logged in as ${user?.email}');
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildFooter(BuildContext context, AuthAction action) {
    if (!kReleaseMode) {
      return ElevatedButton(
        onPressed: () => _signInWithTest(context),
        child: const Text('Sign in with Test Account'),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          _finishLoggedInFlow(context, state.user);
        }),
      ],
      showAuthActionSwitch: false,
      email: 'test@test.com',
      subtitleBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text('to the Vehicle Mileage Tracker (SAF only for now)'),
        );
      },
      footerBuilder: _buildFooter,
    );
  }



}