import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return UserModel(
      uid: doc.data()!['uid'] ?? '',
      name: doc.data()!['name'] ?? '',
      email: doc.data()!['email'] ?? '',
      phoneNumber: doc.data()!['phoneNumber'] ?? '',
    );
  }
}
