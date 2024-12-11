import 'package:ccn_vehicle_mileage_tracker_basic/models/mileage_records.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/utils/app_util.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/utils/firebasedb_util.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/widgets/mileage_record.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  DataSnapshot? vehicleReference;


  @override
  Widget build(BuildContext context) {
    var query = FirebaseDbUtil.getUserVehicleMileageRecords();
    if (query == null) {
      return AppUtil.loggedInUserScaffold(
        context,
        title: "Invalid User",
        body: const Text('You are not logged into the system'),
      );
    }

    if (vehicleReference == null) {
      return AppUtil.loggedInUserScaffold(
        context,
        title: "Loading...",
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return AppUtil.loggedInUserScaffold(
      context,
      title: "Vehicle Mileage Tracker",
      body: FirebaseDatabaseListView(reverseQuery: true, query: query, itemBuilder: (context, snapshot) {
        var records = MileageRecord.fromSnapshot(snapshot);


        print(records);
        return MileageRecordWidget(record: records, vehicles: vehicleReference!);
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    // Retrieve vehicle reference
    var ref = FirebaseDbUtil.getVehicleObjects();
    if (ref != null) {
      ref.once().then((snapshot) {
        setState(() {
          vehicleReference = snapshot.snapshot;
        });
      });
    }
  }
}
