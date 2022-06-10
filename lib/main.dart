import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oiitaxi/pages/map/HomePage.dart';
import 'package:oiitaxi/pages/map/LoginPage.dart';
import 'package:oiitaxi/pages/map/pickUpAndDropLocation.dart';
import 'package:oiitaxi/pages/map/splashScreen.dart';
// import 'package:oiitaxi/pages/map/splashScreen.dart';
import 'package:oiitaxi/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

var finalEmail;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDREgExOxZtBqsAW2LsRhQxZrkCc8RHuTk", // Your apiKey
      appId: "1:997201066351:android:565fe4766b362b4802509a", // Your appId
      messagingSenderId: "997201066351", // Your messagingSenderId
      projectId: "oiitaxi", // Your projectId
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cab Hiring',
      theme: CityTheme.theme,
      home: MySplashScreen(),
    );
  }
}
