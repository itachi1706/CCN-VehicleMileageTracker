
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseDatabase _database = FirebaseDatabase.instance;

class FirebaseDbUtil {

  // Create constants
  static const String USERS = 'users';
  static const String STATISTICS = 'statistics';
  static const String RECORDS = 'records';
  static const String AUTOFILL = 'autofill';
  static const String VEHICLES = 'vehicles';
  static const String MILEAGE_DEC = 'veh_mileage_decimal';
  static const String MILEAGE = 'vehmileage';

  static const int RECORDS_VERSION = 4;

  static String? getFirebaseUid() {
    return _auth.currentUser?.uid;
  }

  static DatabaseReference getVehicleMileageDatabase() {
    return _database.ref(MILEAGE);
  }
  
  static DatabaseReference? getUserVehicleMileageObject() {
    var uid = getFirebaseUid();
    if (uid == null) return null;

    return getVehicleMileageDatabase().child(USERS).child(uid);
  }

  static DatabaseReference? getUserVehicleMileageRecords() {
    return getUserVehicleMileageObject()?.child(RECORDS);
  }

  static DatabaseReference? getUserAutofillRecords() {
    return getUserVehicleMileageObject()?.child(AUTOFILL);
  }

  static DatabaseReference? getVehicleObjects() {
    return getVehicleMileageDatabase()?.child(VEHICLES);
  }


  static const Map<String, String> vehicleClasses = {
    "class2": "Class 2A/2B/2",
    "class3": "Class 3/3A",
    "class4": "Class 4",
    "class4s": "Class 4S (Cargo Trailer)",
    "class5": "Class 5",
    "class4a": "Class 4A (Public Buses)",
    "class1": "Class 1 (Disabled)",
    "class3c": "Class 3C/3CA",
  };
}