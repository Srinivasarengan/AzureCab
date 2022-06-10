import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String linsencePlate;
  final String carModel;
  final String carColor;
  final String carType;

  const DriverModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.linsencePlate,
    required this.carModel,
    required this.carColor,
    required this.carType,
  });

  factory DriverModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return DriverModel(
      uid: doc.data()!['uid'] ?? '',
      name: doc.data()!['name'] ?? '',
      email: doc.data()!['email'] ?? '',
      phoneNumber: doc.data()!['phoneNumber'] ?? '',
      linsencePlate: doc.data()!['linsencePlate'] ?? '',
      carModel: doc.data()!['carModel'] ?? '',
      carColor: doc.data()!['carColor'] ?? '',
      carType: doc.data()!['carType'] ?? '',
    );
  }
}
