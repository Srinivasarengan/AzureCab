import 'package:firebase_database/firebase_database.dart';
import "package:oiitaxi/pages/map/colors.dart" as colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'global.dart';

// import '../driver/signup_driver.dart';

class CustomerSetting extends StatefulWidget {
  const CustomerSetting({Key? key}) : super(key: key);

  @override
  State<CustomerSetting> createState() => _CustomerSettingState();
}

class _CustomerSettingState extends State<CustomerSetting> {
  TextEditingController nameTextEditingController = TextEditingController();
  // TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  // TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.scaffoldbackground,
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile Page",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        backgroundColor: colors.scaffoldbackground,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colors.primarytextcolor),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Container(
                //         decoration: BoxDecoration(
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(8.0)),
                //             color: colors.primarytextcolor),
                //         child: Image.asset(
                //           'assets/homeimage1.png',
                //           fit: BoxFit.fill,
                //           height: 150.0,
                //           width: 200.0,
                //         ),
                //       ),
                //     ),
                //     Column(
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                //           child: ElevatedButton.icon(
                //             icon: Icon(
                //               Icons.edit,
                //               size: 24,
                //               color: colors.buttontextcolor,
                //             ),
                //             label: Text(
                //               "CHANGE",
                //               style: GoogleFonts.montserrat(
                //                   color: colors.buttontextcolor, fontSize: 12),
                //             ),
                //             onPressed: () {},
                //             style: ElevatedButton.styleFrom(
                //                 padding: EdgeInsets.all(10.0),
                //                 primary: colors.buttoncolor,
                //                 shape: new RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(5.0))),
                //           ),
                //         ),
                //         Padding(
                //           padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                //           child: ElevatedButton.icon(
                //             icon: Icon(
                //               Icons.remove,
                //               size: 24,
                //               color: colors.buttontextcolor,
                //             ),
                //             label: Text(
                //               "REMOVE",
                //               style: GoogleFonts.montserrat(
                //                   color: colors.buttontextcolor, fontSize: 12),
                //             ),
                //             onPressed: () {},
                //             style: ElevatedButton.styleFrom(
                //                 padding: EdgeInsets.all(10.0),
                //                 primary: colors.buttoncolor,
                //                 shape: new RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(5.0))),
                //           ),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                // Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colors.primarytextcolor,
                    child: Image.asset(
                      'assets/homeimage1.png',
                      fit: BoxFit.fill,
                      height: 150.0,
                      width: 200.0,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10.0),
                  child: TextFormField(
                      controller: nameTextEditingController,
                      style: GoogleFonts.montserrat(
                          color: colors.primarytextcolor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colors.textboxcolor,
                          hintText: "",
                          hintStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          labelText: "Name",
                          labelStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          suffixIcon: Icon(Icons.edit))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 10.0),
                  child: TextFormField(
                      controller: phoneTextEditingController,
                      style: GoogleFonts.montserrat(
                          color: colors.primarytextcolor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: colors.textboxcolor,
                          hintText: "1234567890",
                          hintStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          labelText: "Phone number",
                          labelStyle: GoogleFonts.poppins(
                              color: colors.hintcolor, fontSize: 18),
                          suffixIcon: Icon(Icons.edit))),
                ),
                Spacer(
                  flex: 2,
                ),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.save,
                      size: 24,
                      color: colors.buttontextcolor,
                    ),
                    label: Text(
                      "SAVE",
                      style: GoogleFonts.montserrat(
                          color: colors.buttontextcolor, fontSize: 12),
                    ),
                    onPressed: () {
// displayDialog(context, "YES", "NO", (){ Navigator.of(context).pop();}, "Save changes", "Are you sure you want to modify your details?");
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: EdgeInsets.all(10.0),
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


class profileNameValidator {
  static validateName(String name) {
    if (name.isEmpty) return "Please enter name!";
    return null;
  }


}

