import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:oiitaxi/pages/map/pickUpAndDropLocation.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key, required this.uid, required this.isDriver})
      : super(key: key);
  final String uid;
  final bool isDriver;
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        print("You are logged in successfully");
        Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
    ).whenComplete(
      () {
        userService().updateVerified(widget.uid, phoneController.text, true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChooseLoc(uid: widget.uid, isDriver: widget.isDriver),
          ),
        );
      },
    );
  }

  bool otpVisibility = false;

  String verificationID = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.scaffoldbackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.scaffoldbackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.primarytextcolor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                      controller: phoneController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.montserrat(
                          color: colors.primarytextcolor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.textboxcolor,
                          hintText: "Phone number",
                          hintStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                ),
              ),
              Visibility(
                child: SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                      controller: otpController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.montserrat(
                          color: colors.primarytextcolor),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.textboxcolor,
                          hintText: "OTP",
                          hintStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                ),
                visible: otpVisibility,
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                color: colors.buttoncolor,
                onPressed: () {
                  if (otpVisibility) {
                    verifyOTP();
                  } else {
                    loginWithPhone();
                  }
                },
                child: Text(
                  otpVisibility ? "Verify" : "Send OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
