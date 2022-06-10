import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oiitaxi/models/AddressModel.dart';

class RideService {
  final _firestoreRideCollection =
      FirebaseFirestore.instance.collection('rides');

  Random random = Random();

  String generateCode(String prefix) {
    var id = random.nextInt(92143543) + 09451234356;
    return '$prefix-${id.toString().substring(0, 8)}';
  }

  List<String> RideModeOptions = ['Car', 'Bike', 'Auto'];
  List<String> RidePreferenceOptions = [
    'None',
    'Pregnant Women',
    'Senior Citzen',
    'Wheelchair',
    'Baby'
  ];

  Future<String> bookRide(
      String uid, AddressModel addressModel, int rideMode, int ridePref) async {
    var fare1 = double.parse(addressModel.distance
        .toString()
        .substring(0, (addressModel.distance.toString().length - 3)));
    print("Fare:$fare1");
    fare1 = fare1 * 20;
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('rides').doc();
    docRef.set({
      'ride_id': docRef.id,
      "startAddress": addressModel.startAddress,
      "endAddress": addressModel.endAddress,
      "distance": addressModel.distance,
      "duration": addressModel.duration,
      "fare": fare1.toString(),
      "startlatLng": {
        'latlng': {
          'lat': addressModel.startlatLng.latitude,
          'lng': addressModel.startlatLng.longitude
        },
      },
      "endlatLng": {
        'latlng': {
          'lat': addressModel.endlatLng.latitude,
          'lng': addressModel.endlatLng.longitude
        },
      },
      'otp': addressModel.otp,
      "driver_uid": "notAssigined",
      "passenger_uid": uid,
      "status": "Booked",
      'createdAt': DateTime.now(),
      'isVerified': false,
      'canceledBy': 'NA',
      'createdAt': DateTime.now(),
      'rideMode': RideModeOptions[(rideMode - 1)],
      'ridePreference': RidePreferenceOptions[(ridePref - 1)],
      'rating': 0.0,
      'ratinPref': 0.0,
      'comments': 'NA',
    });
    return docRef.id.toString();
  }

  Future<bool> updateRideAccept(
      String tripId, String driverId, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('rides').doc(tripId).update({
        'driver_uid': driverId,
        'status': "Accepted",
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tripid': tripId,
        'tripStatus': "inRide",
        'onGoingTrip': "Accepted",
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .update({
        'tripid': tripId,
        'tripStatus': "inRide",
        'onGoingTrip': "Accepted",
        'tripCount': FieldValue.increment(1),
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateVerified(String tripId, String driverId, String userId,
      String otp, String vaildOtp) async {
    if (otp == vaildOtp) {
      try {
        await FirebaseFirestore.instance
            .collection('rides')
            .doc(tripId)
            .update({
          'isVerified': true,
          'status': "Boarded",
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'onGoingTrip': "Boarded",
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(driverId)
            .update({
          'onGoingTrip': "Boarded",
        });
      } catch (e) {
        print(e);
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> cancelRide(
      String tripId, String driverId, String userId, String canceledBy) async {
    try {
      await FirebaseFirestore.instance.collection('rides').doc(tripId).update({
        'status': "Cancelled",
        'canceledBy': canceledBy,
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'onGoingTrip': "Cancelled",
        'tripid': "",
        'tripStatus': "",
        'cancelCount': FieldValue.increment(1),
        'tripCount': FieldValue.increment(-1),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .update({
        'onGoingTrip': "Boarded",
        'onGoingTrip': "Cancelled",
        'tripid': "",
        'tripStatus': "",
        'cancelCount': FieldValue.increment(1),
        'tripCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> updateRideEnd(
      String tripId, String driverId, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('rides').doc(tripId).update({
        'status': "Completed",
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'tripid': "NA",
        'tripStatus': "NA",
        'onGoingTrip': "NA",
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .update({
        'tripid': "NA",
        'tripStatus': "NA",
        'onGoingTrip': "NA",
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
