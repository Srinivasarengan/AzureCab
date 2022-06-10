import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideModel {
  final String rideID;
  final String startAddress;
  final String endAddress;
  final String startLatLng;
  final String endLatLng;
  final String driver_uid;
  final String distance;
  final String duration;
  final String fare;
  final String passenger_uid;
  final String status;
  final bool isVerified;
  final String otp;
  final String canceledBy;
  final Timestamp createdAt;
  final String rideMode;
  final String ridePref;

  const RideModel(
      {required this.rideID,
      required this.startAddress,
      required this.endAddress,
      required this.startLatLng,
      required this.endLatLng,
      required this.driver_uid,
      required this.distance,
      required this.duration,
      required this.fare,
      required this.passenger_uid,
      required this.status,
      required this.isVerified,
      required this.otp,
      required this.canceledBy,
      required this.createdAt,
      required this.rideMode,
      required this.ridePref});

  factory RideModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return RideModel(
      rideID: doc.data()!['rideID'] ?? '',
      startAddress: doc.data()!['startAddress'] ?? '',
      endAddress: doc.data()!['endAddress'] ?? '',
      startLatLng: doc.data()!['startLatLng'] ?? '',
      endLatLng: doc.data()!['endLatLng'] ?? '',
      driver_uid: doc.data()!['driver_uid'] ?? '',
      distance: doc.data()!['distance'] ?? '',
      duration: doc.data()!['duration'] ?? '',
      fare: doc.data()!['fare'] ?? '',
      passenger_uid: doc.data()!['passenger_uid'] ?? '',
      status: doc.data()!['status'] ?? '',
      isVerified: doc.data()!['isVerified'] ?? false,
      otp: doc.data()!['otp'] ?? '',
      canceledBy: doc.data()!['canceledBy'] ?? '',
      createdAt: doc.data()!['createdAt'] ?? '',
      rideMode: doc.data()!['rideMode'] ?? '',
      ridePref: doc.data()!['ridePref'] ?? '',
    );
  }
}
