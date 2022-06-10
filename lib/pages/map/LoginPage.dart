import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oiitaxi/pages/map/AdminPage.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oiitaxi/pages/map/global.dart' as global;
import 'package:oiitaxi/pages/map/SignUpPage.dart';
import 'package:oiitaxi/pages/map/AuthService.dart';
import 'package:oiitaxi/pages/map/pickUpAndDropLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  // TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
        desiredAccuracy: LocationAccuracy.high);
  }

  validateForm() {
    // if(nameTextEditingController.text.length < 5)
    // {
    //   Fluttertoast.showToast(msg: "Name must be atleast 5 character");
    // }

    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Enter Valid email");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
    } else {
      if (emailTextEditingController.text == "admin@gmail.com" &&
          passwordTextEditingController.text == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        loginUserInfo();
      }
    }
  }

  loginUserInfo() async {
    final User? firebaseUser = (await fireAuth
        .signInUsingEmailPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }));

    if (firebaseUser != null) {
      // currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Login Success");
      Position position = await _getGeoLocationPosition();
      print("hi");
      LatLng loc = LatLng(position.latitude, position.longitude);
      bool isLatLng = await userService().updateLocation(firebaseUser.uid, loc);
      bool isDriver = await userService().getUserType(firebaseUser.uid);
      print(isLatLng);
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', firebaseUser.uid);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ChooseLoc(
                  uid: firebaseUser.uid,
                  isDriver: isDriver,
                )),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.scaffoldbackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.scaffoldbackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.primarytextcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 40, 10, 10),
                    child: Text(
                      "LOG IN",
                      style: GoogleFonts.poppins(
                          fontSize: 36, color: colors.primarytextcolor),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.montserrat(
                            color: colors.primarytextcolor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.textboxcolor,
                            hintText: "Email",
                            hintStyle: GoogleFonts.poppins(
                                color: colors.hintcolor, fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        obscureText: true,
                        controller: passwordTextEditingController,
                        style: GoogleFonts.montserrat(
                            color: colors.primarytextcolor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.textboxcolor,
                            hintText: "Password",
                            hintStyle: GoogleFonts.poppins(
                                color: colors.hintcolor, fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                  child: SizedBox(
                    height: 54,
                    width: 314,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.login,
                        size: 24,
                        color: colors.buttontextcolor,
                      ),
                      label: Text(
                        "LOGIN",
                        style: GoogleFonts.montserrat(
                            color: colors.buttontextcolor, fontSize: 18),
                      ),
                      onPressed: () {
                        validateForm();
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          padding: EdgeInsets.all(10.0),
                          primary: colors.buttoncolor,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                    ),
                  ),
                ),
                TextButton(
                  child: Text("Forgot password?"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPwd()),
                    );
                  },
                ),
                TextButton(
                  child: Text("New here? Sign Up"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ForgotPwd extends StatefulWidget {
  const ForgotPwd({Key? key}) : super(key: key);

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  TextEditingController emailTextEditingController = TextEditingController();

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPwd()),
      );
    });

    Fluttertoast.showToast(msg: "Check Your Mail to Reset password!");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.scaffoldbackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.scaffoldbackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.primarytextcolor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: Text(
                      "CHANGE PASSWORD",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: colors.primarytextcolor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 10.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        controller: emailTextEditingController,
                        style: GoogleFonts.montserrat(
                            color: colors.primarytextcolor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.textboxcolor,
                            labelText: "Enter Email",
                            labelStyle: GoogleFonts.poppins(
                                color: colors.hintcolor, fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.save,
                      size: 24,
                      color: colors.buttontextcolor,
                    ),
                    label: Text(
                      "Update",
                      style: GoogleFonts.montserrat(
                          color: colors.buttontextcolor, fontSize: 18),
                    ),
                    onPressed: () {
                      resetPassword(
                          emailTextEditingController.text.trim().toString());
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: EdgeInsets.all(8.0),
                        primary: colors.buttoncolor,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0))),
                  ),
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class loginFormValidator {
  static validateEmail(String email) {
    if (email.isEmpty) return "Please enter an email!";
    RegExp regExp = RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    if (!regExp.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    if (value.length < 8) return 'Password must contain atleast 8 characters.';
    return null;
  }
}
