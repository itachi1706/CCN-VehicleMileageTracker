import 'package:ccn_vehicle_mileage_tracker_basic/models/mileage_records.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/utils/app_util.dart';
import 'package:ccn_vehicle_mileage_tracker_basic/widgets/marquee_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MileageRecordWidget extends StatelessWidget {
  final MileageRecord record;
  final DataSnapshot vehicles;

  MileageRecordWidget({required this.record, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    var vehicleData = 'Unknown Vehicle';
    if (record.vehicleId != null && record.vehicleId!.isNotEmpty) {
      var mapData = vehicles
          .child(record.vehicleClass)
          .child(record.vehicleId!)
          .value as Map;
      vehicleData = mapData["shortname"].toString();
    }

    var dateText =
        '${DateTime.fromMillisecondsSinceEpoch(record.datetimeFrom)} - ${DateTime.fromMillisecondsSinceEpoch(record.dateTimeTo)}';
    print(dateText);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      constraints: const BoxConstraints(
        minHeight: 80.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.destination,
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            record.purpose,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vehicleData,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              SizedBox(
                width: 130.0,
                child: MarqueeText(text: dateText),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.vehicleNumber,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4.0),
              Text(
                '${AppUtil.formatDurationWords(record.totalTimeInMs)} (${record.totalMileage} km)',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: (record.trainingMileage)
                      ? Colors.red
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
