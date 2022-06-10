import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oiitaxi/pages/map/RideModel.dart';
import 'package:oiitaxi/pages/map/UserService.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key, required this.rideModel}) : super(key: key);
  final RideModel rideModel;
  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  var rating = 0.0;
  var ratingPref = 0.0;

  TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate your ride'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Please Rate the Ride'),
                      content: Text('Your Reviews are very important to us'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Rate your ride: $rating",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  setState(() {
                    rating = v;
                  });
                },
                starCount: 5,
                rating: rating,
                size: 40.0,
                color: Colors.blue,
                borderColor: Colors.blue,
                spacing: 0.0,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Visibility(
                visible: widget.rideModel.ridePref != "None",
                child: Column(children: [
                  Text(
                    "Rate your Ride Preference ${widget.rideModel.ridePref} Satisfcation: $ratingPref",
                    style: TextStyle(fontSize: 20),
                  ),
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      setState(() {
                        ratingPref = v;
                      });
                    },
                    starCount: 5,
                    rating: ratingPref,
                    size: 40.0,
                    color: Colors.blue,
                    borderColor: Colors.blue,
                    spacing: 0.0,
                  ),
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Comment: ", style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextField(
                  maxLines: 5,
                  controller: comment,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Comment',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('rides')
                        .doc(widget.rideModel.rideID)
                        .update({
                      'rating': rating,
                      'comment': comment.text,
                      'ratingPref': ratingPref,
                    });
                    await userService().updateRating(
                        widget.rideModel.driver_uid, rating, ratingPref);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ratingValidator {
  static validateComment(String text) {
    if (text.isEmpty) return "Please enter some feedback!";
    return null;
  }
}

