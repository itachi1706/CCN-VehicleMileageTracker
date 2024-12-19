import 'package:ccn_vehicle_mileage_tracker_basic/utils/app_util.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/utils/firebasedb_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewMileageScreen extends StatefulWidget {
  const AddNewMileageScreen({super.key});

  @override
  State<AddNewMileageScreen> createState() => _AddNewMileageScreenState();
}

class _AddNewMileageScreenState extends State<AddNewMileageScreen> {
  bool trainingMileage = false;

  bool userNotLoggedInCheck = false;
  String uid = "";

  Map<String, Map<String, String>> vehicleMapping = {};

  String classType = "class3"; // Default value
  String vehicleSelected = ""; // Default value

  List<String> locationList = [];
  List<String> purposeList = [];
  List<String> vehicleList = [];

  @override
  void initState() {
    super.initState();

    var uid = FirebaseDbUtil.getFirebaseUid();
    if (uid == null) {
      setState(() {
        userNotLoggedInCheck = true;
      });
    } else {
      setState(() {
        userNotLoggedInCheck = false;
        this.uid = uid;
      });
    }

    // Get vehicle list
    debugPrint("Getting vehicle list");
    var vehRef = FirebaseDbUtil.getVehicleObjects();
    vehRef?.once().then((snapshot) {
      debugPrint("Got vehicle list");
      _processVehicleList(snapshot.snapshot);
    });

    debugPrint("Getting autofill records");
    var autocompleteRef = FirebaseDbUtil.getUserAutofillRecords();
    autocompleteRef?.once().then((snapshot) {
      debugPrint("Got autofill records");
      _updateAutoCompleteValues(snapshot.snapshot);
    });
  }

  void _processVehicleList(DataSnapshot snapshot) {
    var vehicleList = snapshot.value as Map?;
    if (vehicleList == null) {
      debugPrint("Vehicle list is null");
      return;
    }

    Map<String, Map<String, String>> vehicleMapping = {};
    vehicleList.forEach((key, value) {
      // Class type
      debugPrint("Processing vehicle class: $key");
      Map<String, String> vehicleClass = {};
      var vehicle = value as Map;
      vehicle.forEach((key, value) {
        vehicleClass[key] = value['name'].toString();
      });
      vehicleMapping[key] = vehicleClass;
    });

    debugPrint(vehicleMapping.toString());

    // From default class get first object
    var firstRecord = vehicleMapping[classType]?.entries.first;

    setState(() {
      this.vehicleMapping = vehicleMapping;
      this.vehicleSelected = firstRecord?.key ?? "";
    });
  }

  void _updateAutoCompleteValues(DataSnapshot snapshot) {
    var locationRaw = snapshot.child('location').value as Map?;
    var purposeRaw = snapshot.child('purpose').value as Map?;
    var vehicleRaw = snapshot.child('vehicleNumber').value as Map?;

    List<String> locationList = [], purposeList = [], vehicleList = [];

    debugPrint("Updating autocomplete values");
    if (locationRaw != null) {
      locationList = List<String>.from(locationRaw.values);
      debugPrint('Location: $locationList');
    }

    if (purposeRaw != null) {
      purposeList = List<String>.from(purposeRaw.values);
      debugPrint('Purpose: $purposeList');
    }

    if (vehicleRaw != null) {
      vehicleList = List<String>.from(vehicleRaw.values);
      debugPrint('Vehicle Numbers: $vehicleList');
    }

    setState(() {
      this.locationList = locationList;
      this.purposeList = purposeList;
      this.vehicleList = vehicleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userNotLoggedInCheck) {
      // TODO: Show prompt to kick user out
      return AppUtil.loggedInUserScaffold(context,
          title: "Not Logged In",
          body: const Center(child: Text("You are not logged in.")));
    }

    if (uid.isEmpty || vehicleMapping.isEmpty) {
      return AppUtil.loadingScreen();
    }

    return AppUtil.loggedInUserScaffold(context,
        title: 'Add New Mileage Record',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Autocomplete(
                optionsViewBuilder: (context, onSelected, options) {
                  var optionsList = options.toList();
                  return Material(
                    elevation: 4.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(optionsList[index]),
                          onTap: () {
                            onSelected(optionsList[index]);
                          },
                        );
                      },
                    ),
                  );
                },
                optionsBuilder: (textEditingValue) {
                  return locationList.where((element) {
                    return element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  debugPrint("Selected location: $value");
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    // onSubmitted: onFieldSubmitted,
                    decoration: const InputDecoration(
                      hintText: 'Location To',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Purpose of Trip',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Vehicle Number',
                  border: OutlineInputBorder(),
                ),
                maxLength: 12,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Mileage Before Trip',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Mileage After Trip',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'From Date/Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => AppUtil.showComingSoonSnackbar(context),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'To Date/Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => AppUtil.showComingSoonSnackbar(context),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Vehicle Class Type: '),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    items: FirebaseDbUtil.vehicleClasses.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        key: Key(entry.key),
                        child: Text(entry.value),
                      );
                    }).toList(),
                    hint: const Text('Select Vehicle Class'),
                    value: classType,
                    onChanged: (changed) {
                      debugPrint("Changed class to $changed");
                      // Get first record of vehicle mapping if any
                      var firstRecord = vehicleMapping[changed]?.entries.first;
                      setState(() {
                        classType = changed!;
                        vehicleSelected = firstRecord?.key ?? "";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Vehicle: '),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    items: vehicleMapping[classType]?.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        key: Key(entry.key),
                        child: Text(entry.value),
                      );
                    }).toList(),
                    hint: const Text('Select Vehicle'),
                    value: vehicleSelected,
                    onChanged: (changed) {
                      debugPrint("Changed vehicle to $changed");
                      setState(() {
                        vehicleSelected = changed!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Training Mileage: '),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: trainingMileage,
                    onChanged: (bool? value) {
                      setState(() {
                        trainingMileage = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add Mileage Record'),
              ),
            ],
          ),
        ));
  }
}
