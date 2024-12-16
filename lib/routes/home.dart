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

  void showPopUp(MileageRecord record) {
    if (vehicleReference == null || record.vehicleId == null) {
      debugPrint("Vehicle reference is null");
      return; // No pop-ups
    }

    var vehicle = vehicleReference!
        .child(record.vehicleClass)
        .child(record.vehicleId!)
        .value as Map;
    print(vehicle);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mileage Record'),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${record.destination}'),
                  Text('Purpose: ${record.purpose}'),
                  Text('Vehicle: ${vehicle["shortname"]}'),
                  Text('Vehicle Full Name: ${vehicle["name"]}'),
                  Text('Vehicle License Plate: ${record.vehicleNumber}'),
                  Text(
                      'From Time: ${DateTime.fromMillisecondsSinceEpoch(record.datetimeFrom)}'),
                  Text(
                      'To: ${DateTime.fromMillisecondsSinceEpoch(record.dateTimeTo)}'),
                  Text('Mileage From: ${record.mileageFrom}'),
                  Text('Mileage To: ${record.mileageTo}'),
                  Text('Total Mileage: ${record.totalMileage}'),
                  Text('Training Mileage: ${record.trainingMileage}'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () {}, child: const Text('Delete')),
            TextButton(onPressed: () {}, child: const Text('Edit')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
      body: FirebaseDatabaseListView(
          reverseQuery: true,
          query: query,
          itemBuilder: (context, snapshot) {
            var records = MileageRecord.fromSnapshot(snapshot);

            print(records);
            return InkWell(
              onTap: () => showPopUp(records),
              child: MileageRecordWidget(
                  record: records, vehicles: vehicleReference!),
            );
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
