import 'package:ccn_vehicle_mileage_tracker_basic/widgets/center_loading_circle.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading...'),
      ),
      body: CenterLoadingCircle(),
    );
  }
}
