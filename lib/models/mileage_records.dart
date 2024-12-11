import 'package:firebase_database/firebase_database.dart';

class MileageRecord {
  final int dateTimeTo;
  final int datetimeFrom;
  final String destination;
  final int mileageFrom;
  final int mileageTo;
  final String purpose;
  final int timezone;
  final int totalMileage;
  final int totalTimeInMs;
  final bool trainingMileage;
  final String vehicleClass;
  final String? vehicleId;
  final String vehicleNumber;
  final int version;

  MileageRecord({
    required this.dateTimeTo,
    required this.datetimeFrom,
    required this.destination,
    required this.mileageFrom,
    required this.mileageTo,
    required this.purpose,
    required this.timezone,
    required this.totalMileage,
    required this.totalTimeInMs,
    required this.trainingMileage,
    required this.vehicleClass,
    required this.vehicleId,
    required this.vehicleNumber,
    required this.version,
  });

  factory MileageRecord.fromSnapshot(DataSnapshot snapshot) {
    var record = Map<String, dynamic>.from(snapshot.value as Map);
    return MileageRecord.fromMap(record);
  }

  factory MileageRecord.fromMap(Map<String, dynamic> map) {
    return MileageRecord(
      dateTimeTo: map['dateTimeTo'],
      datetimeFrom: map['datetimeFrom'],
      destination: map['destination'],
      mileageFrom: map['mileageFrom'],
      mileageTo: map['mileageTo'],
      purpose: map['purpose'],
      timezone: map['timezone'],
      totalMileage: map['totalMileage'],
      totalTimeInMs: map['totalTimeInMs'],
      trainingMileage: map['trainingMileage'],
      vehicleClass: map['vehicleClass'],
      vehicleId: map['vehicleId'],
      vehicleNumber: map['vehicleNumber'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTimeTo': dateTimeTo,
      'datetimeFrom': datetimeFrom,
      'destination': destination,
      'mileageFrom': mileageFrom,
      'mileageTo': mileageTo,
      'purpose': purpose,
      'timezone': timezone,
      'totalMileage': totalMileage,
      'totalTimeInMs': totalTimeInMs,
      'trainingMileage': trainingMileage,
      'vehicleClass': vehicleClass,
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'version': version,
    };
  }

  @override
  String toString() {
    return 'MileageRecord{dateTimeTo: $dateTimeTo, datetimeFrom: $datetimeFrom, destination: $destination, mileageFrom: $mileageFrom, mileageTo: $mileageTo, purpose: $purpose, timezone: $timezone, totalMileage: $totalMileage, totalTimeInMs: $totalTimeInMs, trainingMileage: $trainingMileage, vehicleClass: $vehicleClass, vehicleId: $vehicleId, vehicleNumber: $vehicleNumber, version: $version}';
  }
}