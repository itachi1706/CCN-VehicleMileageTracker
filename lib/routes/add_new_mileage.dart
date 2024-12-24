import 'package:ccn_vehicle_mileage_tracker_basic/utils/app_util.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/utils/firebasedb_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

  String selectedLocation = "";
  String selectedPurpose = "";
  String selectedVehicle = "";

  List<String> locationList = [];
  List<String> purposeList = [];
  List<String> vehicleList = [];

  final TextEditingController fromDateTimeController = TextEditingController();
  final TextEditingController toDateTimeController = TextEditingController();

  int fromDateTime = 0;
  int toDateTime = 0;

  final TextEditingController mileageBeforeController = TextEditingController();
  final TextEditingController mileageAfterController = TextEditingController();

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

  Future<void> _selectFromDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          fromDateTimeController.text = "${DateFormat('dd MMMM yyyy HH:mm').format(finalDateTime)} hrs";
          fromDateTime = finalDateTime.millisecondsSinceEpoch;
        });
      }
    }
  }

  Future<void> _selectToDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          toDateTimeController.text = "${DateFormat('dd MMMM yyyy HH:mm').format(finalDateTime)} hrs";
          toDateTime = finalDateTime.millisecondsSinceEpoch;
        });
      }
    }
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

  bool _validate() {
    // Check if all fields are filled
    if (selectedLocation.isEmpty || selectedPurpose.isEmpty || selectedVehicle.isEmpty || toDateTime == 0 || fromDateTime == 0 || mileageBeforeController.text.isEmpty || mileageAfterController.text.isEmpty) {
      AppUtil.showSnackbarQuick(context, "Please fill up all of the fields and ensure that they are correct");
      return false;
    }

    if (vehicleSelected.isEmpty) {
      AppUtil.showSnackbarQuick(context, "Please select a vehicle type or create a new vehicle type");
      return false;
    }

    if (fromDateTime != 0 && toDateTime != 0 && fromDateTime > toDateTime) {
      AppUtil.showSnackbarQuick(context, "End time cannot be before start time");
      return false;
    }

    if (int.parse(mileageAfterController.text) < int.parse(mileageBeforeController.text)) {
      AppUtil.showSnackbarQuick(context, "Mileage after trip cannot be smaller than the mileage before trip");
      return false;
    }

    return true;

  }

  void _submitForm(BuildContext context) {
    if (!_validate()) {
      return;
    }

    String fromDateTimeStr = fromDateTimeController.text;
    String toDateTimeStr = toDateTimeController.text;
    String mileageBefore = mileageBeforeController.text;
    String mileageAfter = mileageAfterController.text;

    // Process or save the collected values
    debugPrint("From Date/Time: $fromDateTimeStr ($fromDateTime)");
    debugPrint("To Date/Time: $toDateTimeStr ($toDateTime)");
    debugPrint("Mileage Before: $mileageBefore");
    debugPrint("Mileage After: $mileageAfter");
    debugPrint("Destination: $selectedLocation");
    debugPrint("Purpose: $selectedPurpose");
    debugPrint("Vehicle Number: $selectedVehicle");
    debugPrint("Training Mileage: $trainingMileage");
    debugPrint("Vehicle ID: $vehicleSelected");
    debugPrint("Vehicle Class Type: $classType");
    debugPrint("Timezone Offset: ${DateTime.now().timeZoneOffset.inMilliseconds}");
    debugPrint("Total Mileage: ${int.parse(mileageAfter) - int.parse(mileageBefore)}");
    debugPrint("Total Time (ms): ${toDateTime - fromDateTime}");
    debugPrint("Version: ${FirebaseDbUtil.RECORDS_VERSION}");
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
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return locationList.where((element) {
                    return element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  debugPrint("Selected location: $value");
                  setState(() {
                    selectedLocation = value;
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Location To',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Autocomplete(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return purposeList.where((element) {
                    return element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  debugPrint("Selected purpose: $value");
                  setState(() {
                    selectedPurpose = value;
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) {
                      setState(() {
                        selectedPurpose = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Purpose of Trip',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Autocomplete(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return purposeList.where((element) {
                    return element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (value) {
                  debugPrint("Selected vehicle number: $value");
                  setState(() {
                    selectedVehicle = value;
                  });
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Vehicle Number',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 12,
                  );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mileageBeforeController,
                decoration: const InputDecoration(
                  hintText: 'Mileage Before Trip',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mileageAfterController,
                decoration: const InputDecoration(
                  hintText: 'Mileage After Trip',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fromDateTimeController,
                decoration: const InputDecoration(
                  hintText: 'From Date/Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectFromDateTime(context),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: toDateTimeController,
                decoration: const InputDecoration(
                  hintText: 'To Date/Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectToDateTime(context),
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
                onPressed: () => _submitForm(context),
                child: const Text('Add Mileage Record'),
              ),
            ],
          ),
        ));
  }

  // TODO: End time cannot be after start time
// TODO: Mileage after cannot be smaller than mileage before
}
