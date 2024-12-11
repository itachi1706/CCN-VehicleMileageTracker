
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseDatabase _database = FirebaseDatabase.instance;

class FirebaseDbUtil {

  // Create constants
  static const String USERS = 'users';
  static const String STATISTICS = 'statistics';
  static const String RECORDS = 'records';
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

  static DatabaseReference? getVehicleObjects() {
    return getVehicleMileageDatabase()?.child(VEHICLES);
  }


}