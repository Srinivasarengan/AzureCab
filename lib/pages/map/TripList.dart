import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oiitaxi/pages/map/TripDetails.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;
import 'package:flutter/widgets.dart';

class tripList extends StatefulWidget {
  const tripList({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<tripList> createState() => _tripListState();
}

class _tripListState extends State<tripList> {
  Widget buildCard(
    String tripID,
    String fare,
    String pickUp,
    String dropOff,
    String status,
  ) =>
      Card(
        color: status == "NotCompleted"
            ? Colors.orange
            : status == "Canceled"
                ? Colors.red
                : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Trip ID: $tripID",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Fare: ₹$fare.00",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "From: $pickUp",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "To: $dropOff",
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      print("View");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  tripDetails(tripId: tripID)));
                    },
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

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
        title: Text('Trip List'),
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .collection('trips')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                    itemCount: snapshot.data!.docs.length, // error
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index]; // error
                      print("displaying");
                      print(ds['tripid']);

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: buildCard(ds['tripid'], ds['fare'].toString(),
                            ds['startAddress'], ds['endAddress'], ds['status']),
                      );
                    },
                  )
                : Center(
                    child: Text("No Trips Yet... Start New Trip"),
                  );
          },
        ),
      ),
    );
  }
}
