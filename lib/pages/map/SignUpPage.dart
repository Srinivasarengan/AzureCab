import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oiitaxi/pages/map/LoginPage.dart';
import 'package:oiitaxi/pages/map/OTPPage.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;
import 'package:oiitaxi/pages/map/global.dart';
import 'package:oiitaxi/ui/theme.dart';
import 'package:oiitaxi/ui/widgets/textfields/cab_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController genderTextEditingController = TextEditingController();
  // TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleManufacturersController =
      TextEditingController();
  bool isDriver = false;

  validateForm() {
    if (nameTextEditingController.text.length < 5) {
      Fluttertoast.showToast(msg: "Name must be atleast 5 character");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Invalid email");
    }

    // else if(passwordTextEditingController.text.length > 5 && passwordTextEditingController.text.length > 12)
    // {
    //   Fluttertoast.showToast(msg: "Phone Number is required");
    // }

    else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 character");
    } else {
      saveUserInfo();
    }
  }

  saveUserInfo() async {
    final User? firebaseUser = (await fireAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;
    print("isDriver");
    print(isDriver);
    String userType = isDriver ? "driver" : "passenger";
    bool isAdd = await userService().setUpAccount(
        firebaseUser!.uid,
        nameTextEditingController.text.trim(),
        dropdownvalue,
        emailTextEditingController.text.trim(),
        userType,
        licensePlateController.text.trim(),
        vehicleColorController.text.trim(),
        vehicleTypeController.text.trim(),
        vehicleManufacturersController.text.trim());
    print(isAdd);
    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        // "phone" : phoneTextEditingController.text.trim()
      };

      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("details");
      driversRef.child(firebaseUser.uid).set(driverMap);
      // DatabaseReference ref = FirebaseDatabase.instance.ref("details");
      // ref.set(driverMap);
      Fluttertoast.showToast(msg: "Account Created");
      // currentFirebaseUser = firebaseUser;
      // Fluttertoast.showToast(msg: "Account Created");
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', firebaseUser.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  uid: firebaseUser.uid,
                  isDriver: userType == "driver" ? true : false,
                )),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account Not Created");
    }
  }

  String dropdownvalue = 'Male';

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
                    padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: Text(
                      "SIGN UP",
                      style: GoogleFonts.poppins(
                          fontSize: 36, color: colors.primarytextcolor),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        controller: nameTextEditingController,
                        style: GoogleFonts.montserrat(
                            color: colors.primarytextcolor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.textboxcolor,
                            hintText: "Name",
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
                    child: Row(
                      children: [
                        Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade200,
                          ),
                          child: DropdownButton(
                              dropdownColor: Colors.blue,
                              borderRadius: BorderRadius.circular(5.0),
                              // Initial Value
                              value: dropdownvalue,
                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: <String>[
                                'Male',
                                'Female',
                                'Trans Gender',
                                'Others' 
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
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
                  padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                        obscureText: true,
                        style: GoogleFonts.montserrat(
                            color: colors.primarytextcolor),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: colors.textboxcolor,
                            hintText: "Confirm Password",
                            hintStyle: GoogleFonts.poppins(
                                color: colors.hintcolor, fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                  ),
                ),
                Row(
                  children: [
                    CupertinoSwitch(
                      value: isDriver,
                      onChanged: (v) {
                        print(v);
                        setState(() {
                          isDriver = v;
                        });
                      },
                    ),
                    SizedBox(width: CityTheme.elementSpacing * 0.5),
                    Text(
                      'I\'m a Driver',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ).paddingBottom(CityTheme.elementSpacing),
                Builder(builder: (context) {
                  if (isDriver == false) return const SizedBox.shrink();
                  return Column(
                    children: [
                      CityTextField(
                        label: 'Vehicle Type',
                        controller: vehicleTypeController,
                      ).paddingBottom(CityTheme.elementSpacing),
                      CityTextField(
                        label: 'Vehicle Manufacturer',
                        controller: vehicleManufacturersController,
                      ).paddingBottom(CityTheme.elementSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: CityTextField(
                              label: 'Vehicle Color',
                              controller: vehicleColorController,
                            ),
                          ),
                          SizedBox(width: CityTheme.elementSpacing),
                          Expanded(
                            child: CityTextField(
                              label: 'License Plate',
                              controller: licensePlateController,
                            ),
                          ),
                        ],
                      ).paddingBottom(CityTheme.elementSpacing),
                    ],
                  );
                }),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
                  child: SizedBox(
                    height: 54,
                    width: 314,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.app_registration,
                        size: 24,
                        color: colors.buttontextcolor,
                      ),
                      label: Center(
                        child: Text(
                          "SIGN UP",
                          style: GoogleFonts.montserrat(
                              color: colors.buttontextcolor, fontSize: 18),
                        ),
                      ),
                      onPressed: () async {
                        String d = emailTextEditingController.text.trim();
                        validateForm();
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString('email', d);
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
                Spacer(),
                TextButton(
                  child: Text("Already have an account? Log In"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
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
