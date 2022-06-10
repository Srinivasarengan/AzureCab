import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oiitaxi/pages/map/RideModel.dart';

class tripDetails extends StatefulWidget {
  const tripDetails({Key? key, required this.tripId}) : super(key: key);
  final String tripId;
  @override
  State<tripDetails> createState() => _tripDetailsState();
}

class _tripDetailsState extends State<tripDetails> {
  RideModel rideModel = RideModel(
      rideID: "",
      startAddress: "",
      endAddress: "",
      startLatLng: "",
      endLatLng: "",
      driver_uid: "",
      distance: "",
      duration: "",
      fare: "",
      passenger_uid: "",
      status: "",
      isVerified: false,
      otp: "",
      canceledBy: "",
      createdAt: Timestamp.now(),
      rideMode: "",
      ridePref: "");

  @override
  void initState() {
    super.initState();
    getRideDetails().then((value) {
      print("Successfully fetched ride details");
    });
  }

  Future<bool> getRideDetails() async {
    DocumentSnapshot RideSnapshot = await FirebaseFirestore.instance
        .collection('rides')
        .doc(widget.tripId)
        .get();
    Map<String, dynamic> tripData = RideSnapshot.data() as Map<String, dynamic>;
    setState(() {
      rideModel = RideModel(
          rideID: tripData['ride_id'],
          startAddress: tripData['startAddress'],
          endAddress: tripData['endAddress'],
          startLatLng: "",
          endLatLng: "",
          driver_uid: tripData['driver_uid'],
          distance: tripData['distance'],
          duration: tripData['duration'],
          fare: tripData['fare'],
          passenger_uid: tripData['passenger_uid'],
          status: tripData['status'],
          isVerified: tripData['isVerified'],
          otp: tripData['otp'],
          canceledBy: tripData['canceledBy'],
          createdAt: tripData['createdAt'],
          rideMode: tripData['rideMode'],
          ridePref: tripData['ridePreference']);
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Trip Details'),
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Trip ID: ${rideModel.rideID}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "From: ${rideModel.startAddress}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "To: ${rideModel.endAddress}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Distance: ${rideModel.distance}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Duration: ${rideModel.duration}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Fare: ₹${rideModel.fare}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Status: ${rideModel.status}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Driver: ${rideModel.driver_uid}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Passenger: ${rideModel.passenger_uid}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ride Mode: ${rideModel.rideMode}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ride Preference: ${rideModel.ridePref}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Created At: ${DateTime.fromMillisecondsSinceEpoch(rideModel.createdAt.millisecondsSinceEpoch).toString()}",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ]),
      ),
    );
  }
}
