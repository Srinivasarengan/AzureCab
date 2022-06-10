import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart';

class slideUp extends StatefulWidget {
  @override
  _slideUpState createState() => _slideUpState();
}

class _slideUpState extends State<slideUp> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Material(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Drop...",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      splashColor: Colors.white,
                      icon: Icon(
                        Icons.place,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _body() {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        "Cab Hiring",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              leading: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text("Trips"),
              leading: IconButton(
                icon: Icon(
                  Icons.money_off_csred_rounded,
                  color: Colors.blue,
                ),
                onPressed: () {},
              ),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text("Logout"),
              leading: IconButton(
                icon: Icon(
                  Icons.login_rounded,
                  color: Colors.blue,
                ),
                onPressed: () {},
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
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(45.521563, -122.677433),
                  zoom: 15,
                ),
              )),
          Positioned(
            top: 15,
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
                      cursorColor: Colors.blue,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Pick Up...",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.blue,
                            fontSize: 15,
                          )),
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
