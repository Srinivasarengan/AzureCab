import 'dart:async';
// import 'package:cabhiring/';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oiitaxi/pages/map/HomePage.dart';
import 'package:oiitaxi/pages/map/LoginPage.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:oiitaxi/pages/map/global.dart';
import 'package:oiitaxi/pages/map/pickUpAndDropLocation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  // startTimer() {
  //   fireAuth.currentUser != null
  //       ? AssistantMethods.readCurrentOnlineUserInfo()
  //       : null;
  //   Timer(const Duration(seconds: 5), () async {
  //     if (await fireAuth.currentUser != null) {
  //       var currentFirebaseUser = fireAuth.currentUser;
  //       //send user to main screen
  //       Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
  //     } else {
  //       //send user to home screen
  //       Navigator.push(context, MaterialPageRoute(builder: (c) => Home()));
  //     }
  //   });
  // }

  late String uidFromShared;

  Future getUserIDFromSharedPrefs() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var sharedUID = sharedPreferences.getString('uid');
    print("uidshare");
    print(sharedUID.toString());
    setState(() {
      uidFromShared = sharedUID.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    getUserIDFromSharedPrefs().then((value) {
      print("done");
      print(uidFromShared);
      if (uidFromShared == "null") {
        print("Hi");
        Timer(
            Duration(seconds: 1),
            () => Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Home(),
                    ctx: context,
                    reverseDuration: Duration(seconds: 3),
                  ),
                ));
      } else {
        print("1");
        userService().getUserType(uidFromShared).then((value) {
          Timer(
              Duration(seconds: 1),
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChooseLoc(uid: uidFromShared, isDriver: value))));
        });
      }
    });
    // startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/new_logo_v4.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
