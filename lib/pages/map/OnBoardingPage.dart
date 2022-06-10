import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oiitaxi/pages/map/colors.dart' as colors;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:oiitaxi/pages/map/SignUpPage.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: IntroductionScreen(
      pages: [
        PageViewModel(
            title: 'CAB HIRING',
            body: 'Hire a car on hourly or daily payment',
            image: buildImage('assets/undraw_City_driver_re_9xyv.png'),
            decoration: getPageDecoration()),
        PageViewModel(
            title: 'CAB BOOKING',
            body:
                'Choose your pick up and drop location, book a cab and enjoy your trip',
            image: buildImage('assets/undraw_Order_ride_re_372k.png'),
            decoration: getPageDecoration()),
        PageViewModel(
            title: 'EASY ONLINE PAYMENT',
            body: ' Pay using your credit card or GPay for quick transactions',
            image: buildImage('assets/undraw_Mobile_pay_re_sjb8.png'),
            decoration: getPageDecoration()),
        PageViewModel(
          title: 'EASY VERIFICATION PROCESS',
          body: 'Simple steps to verify yourself and your documents',
          image: buildImage('assets/undraw_Certification_re_ifll.png'),
          decoration: getPageDecoration(),
          footer: SizedBox(
            height: 54,
            width: 314,
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.login,
                size: 24,
                color: colors.buttontextcolor,
              ),
              label: Text(
                "SIGN UP",
                style: GoogleFonts.montserrat(
                    color: colors.buttontextcolor, fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
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
      showDoneButton: false,
      showNextButton: false,
    ));
  }

  Widget buildImage(String path) => Center(
        child: Image.asset(
          path,
          width: 350,
        ),
      );
}

PageDecoration getPageDecoration() => PageDecoration(
    titlePadding: EdgeInsets.all(9.0),
    titleTextStyle: GoogleFonts.poppins(
        fontSize: 24,
        color: colors.primarytextcolor,
        fontWeight: FontWeight.w500),
    bodyTextStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: colors.primarytextcolor,
        fontWeight: FontWeight.normal),
    bodyPadding: EdgeInsets.all(10.0),
    pageColor: colors.scaffoldbackground);
