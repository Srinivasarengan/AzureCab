import 'dart:ffi';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel {
  final String id;
  final String startAddress;
  final String endAddress;
  final String distance;
  final String duration;
  final String fare;
  final LatLng startlatLng;
  final LatLng endlatLng;
  final String otp;
  final List<PointLatLng> polylines;

  const AddressModel({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.startlatLng,
    required this.endlatLng,
    required this.otp,
    required this.polylines,
  });

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['id'],
      startAddress: data['startAddress'] ?? '',
      endAddress: data['endAddress'] ?? '',
      distance: data['distance'] ?? '',
      duration: data['duration'] ?? '',
      fare: data['fare'] ?? '',
      startlatLng:
          LatLng(data['startlatLng']['lat'], data['startlatLng']['lng']),
      endlatLng: LatLng(data['endlatLng']['lat'], data['endlatLng']['lng']),
      otp: data['otp'] ?? '',
      polylines: data['polylines'] ?? [],
    );
  }
}
