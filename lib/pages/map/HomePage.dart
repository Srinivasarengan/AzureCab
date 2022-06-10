import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oiitaxi/pages/map/LoginPage.dart';
import 'package:oiitaxi/pages/map/OnBoardingPage.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.scaffoldbackground,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/new_logo_v4.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "God's Ride",
                        style: GoogleFonts.poppins(
                            fontSize: 45,
                            fontWeight: FontWeight.w700,
                            color: colors.primarytextcolor),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 40),
                      child: Text(
                        "Anytime, Anywhere!",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: colors.primarytextcolor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                  ),
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
                        label: Text(
                          "Get Started",
                          style: GoogleFonts.montserrat(
                              color: colors.buttontextcolor, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnBoarding()),
                          );
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
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
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
