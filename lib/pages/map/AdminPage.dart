import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oiitaxi/pages/map/HomePage.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.blue),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home())),
          ),
          title: Text('AdminPage'),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Total Rides'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing:
                                Icon(Icons.car_rental, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Rides'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Total Users'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing: Icon(Icons.account_circle_rounded,
                                color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Users'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'passenger')
                      .snapshots(),
                  builder: (context, snapshot) {
                    num sumTotal = 0;
                    if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((doc) {
                        sumTotal = sumTotal +
                            doc["cancelCount"]; // make sure you create the variable sumTotal somewhere
                      });
                    }
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Canceled Rides'),
                            subtitle: Text(sumTotal.toString()),
                            trailing: Icon(Icons.cancel, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Cancel Rides'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .where('status', isEqualTo: "Booked")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Booked Rides'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing: Icon(Icons.bookmark, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Booked Rides'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .where('status', isEqualTo: "Completed")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Completed Rides'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing:
                                Icon(Icons.check_circle, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Completed Rides'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .where('status', isEqualTo: "Accepted")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Accepted Rides'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing: Icon(Icons.check, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Accepted Rides'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'driver')
                      .where('isActive', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Active Drivers'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing:
                                Icon(Icons.directions_car, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Active Drivers'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'passenger')
                      .where('isActive', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Active Passengers'),
                            subtitle: Text(snapshot.data!.size.toString()),
                            trailing: Icon(Icons.person, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Active Passengers'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .snapshots(),
                  builder: (context, snapshot) {
                    num sumTotal = 0;
                    if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((doc) {
                        sumTotal = sumTotal +
                            double.parse(doc[
                                'fare']); // make sure you create the variable sumTotal somewhere
                      });
                    }
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Total Fare'),
                            subtitle: Text(sumTotal.toString()),
                            trailing:
                                Icon(Icons.attach_money, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Fare'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .snapshots(),
                  builder: (context, snapshot) {
                    num sumTotal = 0;
                    if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((doc) {
                        sumTotal = sumTotal +
                            double.parse(doc[
                                'fare']); // make sure you create the variable sumTotal somewhere
                      });
                    }
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Cash Payement'),
                            subtitle: Text(sumTotal.toString()),
                            trailing: Icon(Icons.money, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Cash Payement'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rides')
                      .snapshots(),
                  builder: (context, snapshot) {
                    num sumTotal = 0;
                    if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((doc) {
                        sumTotal = sumTotal +
                            double.parse(doc[
                                'fare']); // make sure you create the variable sumTotal somewhere
                      });
                    }
                    return snapshot.hasData
                        ? ListTile(
                            title: Text('Card Payement'),
                            subtitle: Text(sumTotal.toString()),
                            trailing:
                                Icon(Icons.credit_card, color: Colors.blue),
                          )
                        : ListTile(
                            title: Text('Card Payemnet'),
                            subtitle: Text("Fecting Data from Firebase"),
                          );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
