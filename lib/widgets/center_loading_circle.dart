import 'package:flutter/material.dart';

class CenterLoadingCircle extends StatelessWidget {
  final String loadingText;

  const CenterLoadingCircle({super.key, this.loadingText = 'Getting Data'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 16.0),
          Text(loadingText),
        ],
      ),
    );
  }
}
