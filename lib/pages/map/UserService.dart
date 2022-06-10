import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userService {
  Future<bool> setUpAccount(
    String uid,
    String name,
    String gender,
    String email,
    String userType,
    String license,
    String color,
    String model,
    String manfu,
  ) async =>
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'uid': uid,
        'email': email,
        'gender': gender,
        'isActive': false,
        'isVerified': false,
        'phoneNumber': '',
        'latlng': {
          'lat': 10.8978,
          'lng': 76.9038,
        },
        'createdAt': DateTime.now(),
        'rating': 0.0,
        'ratingPref': 0.0,
        'tripCount': 0,
        'cancelCount': 0,
        'tripid': "NA",
        'tripStatus': "NA",
        'onGoingTrip': "",
        'userType': userType,
        'licensePlate': license,
        'carModel': model,
        'carColor': color,
        'carType': manfu,
      }).then((_) {
        print("Done");

        return true;
      }).catchError((error) {
        print(error);
        return false;
      });

  Future<bool> updatRideList(String uid, String trip_id, String distance,
      String startAddress, String endAddress, String status) async {
    var fare1 = double.parse(
        distance.toString().substring(0, (distance.toString().length - 3)));
    print("Fare:$fare1");
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('trips')
          .add({
        'tripid': trip_id,
        'fare': fare1,
        'createdAt': DateTime.now(),
        'startAddress': startAddress,
        'endAddress': endAddress,
        'status': status,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateVerified(
      String uid, String number, bool isVeriified) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'phoneNumber': number,
        'isVerified': isVeriified,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateLocation(String uid, LatLng point) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isActive': true,
        'latlng': {
          'lat': point.latitude,
          'lng': point.longitude,
        },
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateTrip(String uid, String tripId, String tripStatus) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'tripStatus': "inRide",
        'tripid': tripId,
        'tripCount': FieldValue.increment(1),
        'onGoingTrip': tripStatus
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> getUserType(String uid) async {
    try {
      var user =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return user.data()!['userType'] == 'driver' ? true : false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateActiveTrue(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isActive': true,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateActiveFalse(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isActive': false,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateRating(
      String uid, double rating, double ratingPref) async {
    DocumentSnapshot driverData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> data = driverData.data() as Map<String, dynamic>;
    double oldRating = double.parse(data['rating'].toString());
    if (oldRating == 0.0) {
      oldRating = rating;
    }
    double newRating = (oldRating + rating) / 2;
    double oldRatingPref = double.parse(data['ratingPref'].toString());
    if (oldRatingPref == 0.0) {
      oldRatingPref = ratingPref;
    }
    double newRatingPref = (oldRatingPref + ratingPref) / 2;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'rating': newRating,
        'ratingPref': newRatingPref,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
