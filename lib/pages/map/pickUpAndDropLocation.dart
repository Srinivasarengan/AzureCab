import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glass/glass.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:oiitaxi/models/AddressModel.dart';
import 'package:oiitaxi/pages/map/AdminPage.dart';
import 'package:oiitaxi/pages/map/HomePage.dart';
import 'package:oiitaxi/pages/map/LocatioinService.dart';
import 'package:oiitaxi/pages/map/DriverModel.dart';
import 'package:oiitaxi/pages/map/RatingPage.dart';
import 'package:oiitaxi/pages/map/RideModel.dart';
import 'package:oiitaxi/pages/map/RideService.dart';
import 'package:oiitaxi/pages/map/TripList.dart';
import 'package:oiitaxi/pages/map/UserModel.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:oiitaxi/pages/map/auth.dart';
import 'package:oiitaxi/pages/map/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oiitaxi/pages/map/getLocation.dart';
import 'package:oiitaxi/pages/map/profileUpdate.dart';

import 'package:oiitaxi/ui/theme.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'dart:ui';
import 'dart:async';

import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ChooseLoc extends StatefulWidget {
  const ChooseLoc({Key? key, required this.uid, required this.isDriver})
      : super(key: key);
  final String uid;
  final bool isDriver;
  @override
  State<ChooseLoc> createState() => _ChooseLocState();
}

class _ChooseLocState extends State<ChooseLoc> {
  final Completer<GoogleMapController> _controller = Completer();

  final LatLng _center = const LatLng(45.521563, -122.677433);

  String location = 'Null, Press Button';
  String Address = 'search';

  TextEditingController _pickUpSearchController = TextEditingController();
  TextEditingController _dropSearchController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String pickUpAddress = 'Null';
  String dropAddress = 'Null';

  String userGender = 'Null';

  late AddressModel addressModel = AddressModel(
      id: "0",
      startAddress: "startAddress",
      endAddress: "endAddress",
      distance: "distance",
      duration: "duration",
      fare: "0.0",
      startlatLng: LatLng(0, 0),
      endlatLng: LatLng(0, 0),
      otp: "otp",
      polylines: []);

  String otp = "";
  String estimatedFare = "0.0";

  bool onConfirmRide = false;
  bool OnDriverAccept = false;
  bool tripSatus = false;
  bool isOtpVerified = false;
  DriverModel driverModel = DriverModel(
      uid: "",
      name: "",
      email: "",
      phoneNumber: "",
      linsencePlate: "",
      carModel: "",
      carColor: "",
      carType: "");

  UserModel userModel =
      UserModel(uid: "", name: "", email: "", phoneNumber: "");
  UserModel currentUserModel =
      UserModel(uid: "", name: "", email: "", phoneNumber: "");
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

  var rideModeSelected = 1;
  var ridePreferenceSelected = 1;

  var rating = 3.0;

  @override
  void initSate() {
    super.initState();
    userService().updateActiveTrue(widget.uid).then((value) {
      print("User Active");
    });
    setState(() {
      checkStatus = false;
    });
  }

  void dispose() {
    super.dispose();
    userService().updateActiveFalse(widget.uid).then((value) {
      print("user updated");
    });
  }

  Future<bool> checkTripStatusAndGetDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print(data['tripid']);
      print(data['tripStatus']);
      if (data['tripStatus'] == 'inRide') {
        print("Trip Status true");
        if (data['userType'] == "passenger") {
          print("you are passenger");
          DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
              .collection('rides')
              .doc(data['tripid'])
              .get();

          Map<String, dynamic> tripData =
              tripSnapshot.data() as Map<String, dynamic>;
          print("Status is $tripData['status']");
          rideModel = RideModel(
              rideID: tripData['ride_id'],
              startAddress: tripData['startAddress'],
              endAddress: tripData['endAddress'],
              startLatLng: "10",
              endLatLng: "15",
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
          if (rideModel.driver_uid != "notAssigined") {
            DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(tripData['driver_uid'])
                .get();
            Map<String, dynamic> driverData =
                driverSnapshot.data() as Map<String, dynamic>;
            setState(() {
              tripSatus = true;
              userGender = data['gender'];
              isOtpVerified = tripData['isVerified'];
              currentUserModel = UserModel(
                  uid: data['uid'],
                  name: data['name'],
                  email: data['email'],
                  phoneNumber: data['phoneNumber']);
              rideModel = RideModel(
                  rideID: tripData['ride_id'],
                  startAddress: tripData['startAddress'],
                  endAddress: tripData['endAddress'],
                  startLatLng: "10",
                  endLatLng: "15",
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
              driverModel = DriverModel(
                  uid: driverData['uid'],
                  name: driverData['name'],
                  email: driverData['email'],
                  phoneNumber: driverData['phoneNumber'],
                  linsencePlate: driverData['licensePlate'],
                  carModel: driverData['carModel'],
                  carColor: driverData['carColor'],
                  carType: driverData['carType']);
            });
          } else {
            setState(() {
              tripSatus = true;
              userGender = data['gender'];
              currentUserModel = UserModel(
                  uid: data['uid'],
                  name: data['name'],
                  email: data['email'],
                  phoneNumber: data['phoneNumber']);
              rideModel = RideModel(
                  rideID: tripData['ride_id'],
                  startAddress: tripData['startAddress'],
                  endAddress: tripData['endAddress'],
                  startLatLng: "10",
                  endLatLng: "15",
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
          }
          print("isVerified: ${tripData['isVerified']}");
        } else {
          print("You are driver");

          DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
              .collection('rides')
              .doc(data['tripid'])
              .get();
          Map<String, dynamic> tripData =
              tripSnapshot.data() as Map<String, dynamic>;
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
          print(rideModel);
          print(tripData);
          print(tripData['isVerified']);
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(tripData['passenger_uid'])
              .get();
          Map<String, dynamic> UserData =
              userSnapshot.data() as Map<String, dynamic>;
          print("updating userinfo");
          setState(() {
            tripSatus = true;
            userGender = data['gender'];
            isOtpVerified = tripData['isVerified'];
            currentUserModel = UserModel(
                uid: data['uid'],
                name: data['name'],
                email: data['email'],
                phoneNumber: data['phoneNumber']);
            userModel = UserModel(
                uid: UserData['uid'],
                name: UserData['name'],
                email: UserData['email'],
                phoneNumber: UserData['phoneNumber']);
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
        }
        return true;
      } else {
        setState(() {
          tripSatus = false;
          userGender = data['gender'];
          currentUserModel = UserModel(
              uid: data['uid'],
              name: data['name'],
              email: data['email'],
              phoneNumber: data['phoneNumber']);
        });
        return false;
      }
    } else {
      setState(() {
        tripSatus = false;
      });

      return false;
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<String> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    print(
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}');
    return place.locality.toString();
  }

  Future<String> GetAddressFromLatLong1(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    String Address = '${place.street},${place.locality},${place.country}';
    return Address;
  }

  Set<Marker> _markers = Set<Marker>();

  late List<PointLatLng> _info;
  bool needRoute = false;

  void _setPickUpMarker(LatLng point, String name) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('PickUp'),
        infoWindow: InfoWindow(title: name),
        position: point,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _setDropMarker(LatLng point, String name) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Drop'),
        position: point,
        infoWindow: InfoWindow(title: name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    });
  }

  Future<void> _goToPickUpPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    final String name = place['name'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));

    _setPickUpMarker(LatLng(lat, lng), name);
    String address = await GetAddressFromLatLong1(LatLng(lat, lng));
    setState(() {
      pickUpAddress = address;
    });
  }

  Future<void> _goToDropPlace(
      Map<String, dynamic> pickUpPlace, Map<String, dynamic> dropPlace) async {
    final double pickUPLat = pickUpPlace['geometry']['location']['lat'];
    final double pickUpLng = pickUpPlace['geometry']['location']['lng'];
    final double dropLat = dropPlace['geometry']['location']['lat'];
    final double dropLng = dropPlace['geometry']['location']['lng'];
    final String name = dropPlace['name'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(dropLat, dropLng), zoom: 12),
    ));

    _setDropMarker(LatLng(dropLat, dropLng), name);
    var god = await LocationService()
        .getPolylines(LatLng(pickUPLat, pickUpLng), LatLng(dropLat, dropLng));
    String address = await GetAddressFromLatLong1(LatLng(dropLat, dropLng));
    var am = await LocationService().getPolylinesInfo(
        LatLng(pickUPLat, pickUpLng), LatLng(dropLat, dropLng));
    print("am $am");
    var fare1 = double.parse(am.distance
        .toString()
        .substring(0, (am.distance.toString().length - 3)));
    print("Fare:$fare1");
    fare1 = fare1 * 20;
    setState(() {
      _info = god;
      needRoute = true;
      dropAddress = address;
      addressModel = am;
      estimatedFare = fare1.toString();
    });
  }

  Widget buildCard(
    String tripID,
    String fare,
    String passenger_uid,
    String pickUp,
    String dropOff,
    String preference,
  ) =>
      Card(
        elevation: 5,
        color: preference == "None" ? Colors.grey : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            children: [
              Visibility(
                visible: preference != "Female",
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
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Prefernce: $preference",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              RideService().updateRideAccept(
                                tripID,
                                widget.uid,
                                passenger_uid,
                              );
                              userService().updatRideList(widget.uid, tripID,
                                  fare, pickUp, dropOff, "NotCompleted");
                              await checkTripStatusAndGetDetails();
                              setState(() {
                                OnDriverAccept = true;
                                tripSatus = true;
                              });
                            },
                            icon: Icon(Icons.check_circle_outline_rounded,
                                size: 18),
                            label: Text("Accept"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: preference == "Female" && userGender == "Female",
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
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Prefernce: $preference",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              RideService().updateRideAccept(
                                tripID,
                                widget.uid,
                                passenger_uid,
                              );
                              userService().updatRideList(widget.uid, tripID,
                                  fare, pickUp, dropOff, "NotCompleted");
                              await checkTripStatusAndGetDetails();
                              setState(() {
                                OnDriverAccept = true;
                                tripSatus = true;
                              });
                            },
                            icon: Icon(Icons.check_circle_outline_rounded,
                                size: 18),
                            label: Text("Accept"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkStatus = false;
  @override
  Widget build(BuildContext context) {
    print("tripStatus $tripSatus");
    print(rating);
    if (checkStatus == false) {
      userService().updateActiveTrue(widget.uid).then((value) {
        print("User Active");
      });
      checkTripStatusAndGetDetails().then((value) {
        setState(() {
          checkStatus = true;
        });
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Color(0xB30097A7),
        child: Column(
          children: [
            //drawer header user info
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              accountName: Text(
                currentUserModel.name,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              accountEmail: Text(
                currentUserModel.email,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              currentAccountPicture: currentUserModel.name.length > 0
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        currentUserModel.name.substring(0, 1),
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        "GR",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            ListTile(
              title: Text("Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              leading: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CustomerSetting()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text("Trips",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              leading: IconButton(
                icon: Icon(
                  Icons.money_off_csred_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tripList(uid: widget.uid)));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text("About",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              leading: IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            ListTile(
              title: Text("Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              leading: IconButton(
                icon: Icon(
                  Icons.login_rounded,
                  color: Colors.white,
                ),
                onPressed: () async {
                  print("Logout");
                  await userService().updateActiveFalse(widget.uid);
                  AuthService.instance?.logOut();
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('uid');

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Home()));
                },
              ),
              onTap: () async {
                print("Logout");
                AuthService.instance?.logOut();
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove('uid');

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()));
              },
            ),
            Spacer(),
            ListTile(
              title: Text("Version 2.1.6",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300)),
              leading: IconButton(
                icon: Icon(
                  Icons.logo_dev_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Replace this container with your Map widget
          Container(
              color: Colors.black,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                myLocationEnabled: true,
                polylines: {
                  if (needRoute)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.blue,
                      width: 5,
                      points: _info
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(45.521563, -122.677433),
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              )),
          Visibility(
              visible: tripSatus || widget.isDriver,
              child: Positioned(
                  top: 60,
                  left: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: Colors.blue,
                    ),
                  ))),
          Visibility(
            visible: tripSatus == false && widget.isDriver == false,
            child: Positioned(
              top: 60,
              right: 15,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: Colors.blue,
                      icon: Icon(
                        Icons.menu,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _pickUpSearchController,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            fillColor: Colors.blue,
                            hintText: "Pick Up...",
                            hintStyle: GoogleFonts.roboto(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        splashColor: Colors.blue,
                        icon: Icon(
                          Icons.location_searching_rounded,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          Position position = await _getGeoLocationPosition();
                          print("hi");
                          LatLng loc =
                              LatLng(position.latitude, position.longitude);
                          location =
                              'Lat: ${position.latitude} , Long: ${position.longitude}';

                          String currentLocationName =
                              await GetAddressFromLatLong(position);
                          _setPickUpMarker(loc, currentLocationName);
                          _pickUpSearchController.text = currentLocationName;
                          var place = await LocationService()
                              .getPlace(_pickUpSearchController.text);
                          _goToPickUpPlace(place);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        splashColor: Colors.blue,
                        icon: Icon(
                          Icons.place,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          print("PickUp controller");
                          var place = await LocationService()
                              .getPlace(_pickUpSearchController.text);
                          _goToPickUpPlace(place);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SlidingUpPanel(
              panelSnapping: true,
              color: Color(0x660097A7),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              panel: Column(
                children: [
                  Visibility(
                    visible: widget.isDriver == false,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Visibility(
                          visible: tripSatus == false,
                          child: Column(children: [
                            Visibility(
                              visible: widget.isDriver == false,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _dropSearchController,
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            fillColor: Colors.blue,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 15),
                                            hintText: "Drop...",
                                            hintStyle: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        splashColor: Colors.white,
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          var pickUpPlace =
                                              await LocationService().getPlace(
                                                  _pickUpSearchController.text);
                                          var dropPlace =
                                              await LocationService().getPlace(
                                                  _dropSearchController.text);
                                          _goToDropPlace(
                                              pickUpPlace, dropPlace);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Visibility(
                              visible: needRoute,
                              child: Center(
                                child: Row(
                                  children: [
                                    Text("Distance:",
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Text(addressModel.distance,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: needRoute,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Time:",
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text(addressModel.duration,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: needRoute,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Estimated Fare:",
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text("₹" + estimatedFare,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Visibility(
                                visible: onConfirmRide != true,
                                child: Visibility(
                                  visible: needRoute,
                                  child: Text("Ride Mode:",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                )),
                            Visibility(
                                visible: onConfirmRide != true,
                                child: Visibility(
                                  visible: needRoute,
                                  child: SizedBox(
                                    height: 60.0,
                                    child: ListView(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  rideModeSelected = 1;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.directions_car,
                                                    color: rideModeSelected == 1
                                                        ? Colors.blue
                                                        : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Car",
                                                    style: GoogleFonts.roboto(
                                                      color:
                                                          rideModeSelected == 1
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  rideModeSelected = 2;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.directions_bike,
                                                    color: rideModeSelected == 2
                                                        ? Colors.blue
                                                        : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Bike",
                                                    style: GoogleFonts.roboto(
                                                      color:
                                                          rideModeSelected == 2
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  rideModeSelected = 3;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .electric_rickshaw_rounded,
                                                    color: rideModeSelected == 3
                                                        ? Colors.blue
                                                        : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Auto",
                                                    style: GoogleFonts.roboto(
                                                      color:
                                                          rideModeSelected == 3
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 15.0,
                            ),
                            Visibility(
                                visible: onConfirmRide != true,
                                child: Visibility(
                                  visible: needRoute,
                                  child: Text("Ride Preferences:",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      )),
                                )),
                            Visibility(
                                visible: onConfirmRide != true,
                                child: Visibility(
                                  visible: needRoute,
                                  child: SizedBox(
                                    height: 60.0,
                                    child: ListView(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  ridePreferenceSelected = 1;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.not_interested,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                1
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "None",
                                                    style: GoogleFonts.roboto(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  1
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  rideModeSelected = 2;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.pregnant_woman,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                2
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Pregnant Woman",
                                                    style: TextStyle(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  2
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  ridePreferenceSelected = 3;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.elderly,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                3
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Senior Citizen",
                                                    style: TextStyle(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  3
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  ridePreferenceSelected = 4;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.accessible,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                4
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Wheelchair",
                                                    style: TextStyle(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  4
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  ridePreferenceSelected = 5;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.baby_changing_station,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                5
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Baby",
                                                    style: TextStyle(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  5
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          elevation: 5,
                                          child: Container(
                                            width: 100,
                                            child: FlatButton(
                                              onPressed: () async {
                                                DocumentSnapshot userInfo =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(widget.uid)
                                                        .get();
                                                Map<String, dynamic> UserData =
                                                    userInfo.data()
                                                        as Map<String, dynamic>;
                                                if (UserData['gender'] ==
                                                    'Female') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Women Safety:"),
                                                          content: Text(
                                                              'Your Safety is our Concern'),
                                                          actions: [
                                                            FlatButton(
                                                              child: Text("Ok"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Alert Info:"),
                                                          content: Text(
                                                              'Only available for Female Passengers'),
                                                          actions: [
                                                            FlatButton(
                                                              child: Text("Ok"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                }
                                                if (UserData['gender'] ==
                                                    'Female') {
                                                  setState(() {
                                                    ridePreferenceSelected = 6;
                                                  });
                                                } else {
                                                  setState(() {
                                                    ridePreferenceSelected = 1;
                                                  });
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.female_rounded,
                                                    color:
                                                        ridePreferenceSelected ==
                                                                6
                                                            ? Colors.blue
                                                            : Colors.black,
                                                    size: 30,
                                                  ),
                                                  Text(
                                                    "Female Driver",
                                                    style: TextStyle(
                                                      color:
                                                          ridePreferenceSelected ==
                                                                  6
                                                              ? Colors.blue
                                                              : Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 15.0,
                            ),
                            Visibility(
                              visible: onConfirmRide != true,
                              child: Visibility(
                                visible: needRoute,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    String tripId = await RideService()
                                        .bookRide(
                                            widget.uid,
                                            addressModel,
                                            rideModeSelected,
                                            ridePreferenceSelected);
                                    print(tripId);
                                    bool isTrip = await userService()
                                        .updateTrip(
                                            widget.uid, tripId, "Booked");
                                    print(isTrip);
                                    userService().updatRideList(
                                        widget.uid,
                                        tripId,
                                        addressModel.distance,
                                        addressModel.startAddress,
                                        addressModel.endAddress,
                                        "NotCompleted");
                                    await checkTripStatusAndGetDetails();
                                    print("printing ststus $rideModel.status");
                                    setState(() {
                                      onConfirmRide = true;
                                      tripSatus = true;
                                    });
                                  },
                                  icon: Icon(Icons.check_circle_rounded,
                                      size: 18),
                                  label: Text("Confirm Ride"),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Visibility(
                          visible: (tripSatus && isOtpVerified == false),
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  print(true);
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  if (data['onGoingTrip'] == "Accepted") {
                                    checkTripStatusAndGetDetails()
                                        .then((value) {
                                      setState(() {
                                        isOtpVerified = true;
                                      });
                                    });
                                    return Text("Your Ride is on the way",
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ));
                                  } else {
                                    return Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                        Text(
                                            "Your trip is Confirmed wait for the driver to accept your request",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    );
                                  }
                                } else {
                                  return Text("Error");
                                }
                              }),
                        ),
                        Visibility(
                          visible: tripSatus,
                          child: Visibility(
                            visible: rideModel.isVerified == false,
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.uid)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    print(true);
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    if (data['onGoingTrip'] == "Accepted") {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("OTP:",
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          Text(rideModel.otp,
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              )),
                                        ],
                                      );
                                    } else {
                                      return Text("");
                                    }
                                  } else {
                                    return Text("Error");
                                  }
                                }),
                          ),
                        ),
                        Visibility(
                          visible: isOtpVerified,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Color.fromARGB(255, 3, 245, 11),
                                    size: 24,
                                  ),
                                  Text(
                                    "Your Ride is Verified",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.account_circle,
                                      color: Colors.white, size: 40),
                                  Column(
                                    children: [
                                      Text(driverModel.name,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      Text(
                                        driverModel.linsencePlate,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.contact_support_rounded,
                                        size: 18),
                                    label: Text("Support"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      FlutterPhoneDirectCaller.callNumber(
                                          "+91" + driverModel.phoneNumber);
                                    },
                                    icon: Icon(Icons.phone, size: 18),
                                    label: Text("Call"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await RideService().cancelRide(
                                          rideModel.rideID,
                                          rideModel.driver_uid,
                                          rideModel.passenger_uid,
                                          "passenger");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ChooseLoc(
                                                      uid: widget.uid,
                                                      isDriver:
                                                          widget.isDriver)));
                                    },
                                    icon: Icon(Icons.cancel, size: 18),
                                    label: Text("Cancel"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await RideService().updateRideEnd(
                                              rideModel.rideID,
                                              rideModel.driver_uid,
                                              rideModel.passenger_uid);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RatingPage(
                                                      rideModel: rideModel,
                                                    )),
                                          );
                                          await checkTripStatusAndGetDetails();
                                          setState(() {
                                            isOtpVerified = false;
                                          });
                                        },
                                        child: Text(
                                          "End Ride",
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.isDriver,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Visibility(
                          visible: OnDriverAccept == false,
                          child: Column(children: [
                            Visibility(
                              visible: tripSatus == false,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    bool isUpdateActive = await userService()
                                        .updateActiveTrue(widget.uid);
                                  },
                                  icon:
                                      Icon(Icons.power_settings_new, size: 18),
                                  label: Text("Go offline"),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: tripSatus == false,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('rides')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.hasData
                                        ? SizedBox(
                                            height: 350,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                color: Colors.grey,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                DocumentSnapshot ds = snapshot
                                                    .data!.docs[index]; // error
                                                print("displaying");
                                                print(ds['distance']);
                                                if (ds["status"] == "Booked" &&
                                                    ds["rideMode"] == 'Car') {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color:
                                                            Colors.transparent),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                    child: buildCard(
                                                        ds['ride_id'],
                                                        ds['fare'],
                                                        ds['passenger_uid'],
                                                        ds['startAddress'],
                                                        ds['endAddress'],
                                                        ds['ridePreference']),
                                                    // child: ListTile(
                                                    //   textColor: Colors.white,
                                                    //   title: Text(
                                                    //       ds['passenger_uid']
                                                    //           .toString()
                                                    //           .substring(0, 10)),
                                                    //   subtitle: Text(
                                                    //       ds['endAddress']
                                                    //           .toString()
                                                    //           .substring(0, 10)),
                                                    //   trailing: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.min,
                                                    //     children: [
                                                    //       ElevatedButton.icon(
                                                    //         onPressed: () async {
                                                    //           RideService()
                                                    //               .updateRideAccept(
                                                    //             ds['ride_id'],
                                                    //             widget.uid,
                                                    //             ds['passenger_uid'],
                                                    //           );
                                                    //           userService().updatRideList(
                                                    //               widget.uid,
                                                    //               ds['ride_id'],
                                                    //               ds['fare'],
                                                    //               ds['startAddress'],
                                                    //               ds['endAddress'],
                                                    //               "NotCompleted");
                                                    //           await checkTripStatusAndGetDetails();
                                                    //           setState(() {
                                                    //             OnDriverAccept =
                                                    //                 true;
                                                    //             tripSatus = true;
                                                    //           });
                                                    //         },
                                                    //         icon: Icon(
                                                    //             Icons
                                                    //                 .check_circle_outline_rounded,
                                                    //             size: 18),
                                                    //         label: Text("Accept"),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                  },
                                ),
                              ),
                            )
                          ]),
                        ),
                        Visibility(
                          visible: tripSatus,
                          child: Visibility(
                              visible: isOtpVerified == false,
                              child: Column(
                                children: [
                                  Text(userModel.name,
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  Text(
                                    userModel.phoneNumber,
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "OTP",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  OtpTextField(
                                    numberOfFields: 4,
                                    borderColor: Color(0xFF512DA8),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                      //handle validation or checks here
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String verificationCode) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Verification Code"),
                                              content: Text(
                                                  'Code entered is $verificationCode'),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                      setState(() {
                                        otp = verificationCode;
                                      });
                                    }, // end onSubmit
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent,
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        await RideService().updateVerified(
                                            rideModel.rideID,
                                            rideModel.driver_uid,
                                            rideModel.passenger_uid,
                                            otp.toString(),
                                            rideModel.otp);
                                        await checkTripStatusAndGetDetails();
                                      },
                                      icon: Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 18),
                                      label: Text("Verify"),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Visibility(
                          visible: isOtpVerified == true,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Color.fromARGB(255, 3, 245, 11),
                                    size: 24,
                                  ),
                                  Text(
                                    "Your Ride is Verified",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.account_circle,
                                      color: Colors.white, size: 40),
                                  Column(
                                    children: [
                                      Text(userModel.name,
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      Text(
                                        userModel.phoneNumber,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {},
                                    icon: Icon(Icons.contact_support_rounded,
                                        size: 18),
                                    label: Text("Support"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      FlutterPhoneDirectCaller.callNumber(
                                          "+91" + userModel.phoneNumber);
                                    },
                                    icon: Icon(Icons.phone, size: 18),
                                    label: Text("Call"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await RideService().cancelRide(
                                          rideModel.rideID,
                                          rideModel.driver_uid,
                                          rideModel.passenger_uid,
                                          "driver");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ChooseLoc(
                                                      uid: widget.uid,
                                                      isDriver:
                                                          widget.isDriver)));
                                    },
                                    icon: Icon(Icons.cancel, size: 18),
                                    label: Text("Cancel"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
