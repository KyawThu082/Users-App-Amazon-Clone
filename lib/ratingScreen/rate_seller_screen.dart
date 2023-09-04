import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

// ignore: must_be_immutable
class RateSellerScreen extends StatefulWidget {
  String? sellerId;
  RateSellerScreen({super.key, this.sellerId});

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        backgroundColor: Colors.white60,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 22),
              const Text(
                "Rate this Seller",
                style: TextStyle(
                  fontSize: 22,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              const Divider(
                height: 4,
                thickness: 4,
              ),
              const SizedBox(height: 22),
              SmoothStarRating(
                rating: countStarsRating,
                allowHalfRating: true,
                starCount: 5,
                color: Colors.purpleAccent,
                borderColor: Colors.purpleAccent,
                size: 46,
                onRatingChanged: (valueOfStarsChoosed) {
                  countStarsRating = valueOfStarsChoosed;

                  if (countStarsRating == 1) {
                    setState(() {
                      titleStarRating = "Very Bad";
                    });
                  }
                  if (countStarsRating == 2) {
                    setState(() {
                      titleStarRating = "Bad";
                    });
                  }
                  if (countStarsRating == 3) {
                    setState(() {
                      titleStarRating = "Good";
                    });
                  }
                  if (countStarsRating == 4) {
                    setState(() {
                      titleStarRating = "Very Good";
                    });
                  }
                  if (countStarsRating == 5) {
                    setState(() {
                      titleStarRating = "Excellent";
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              Text(
                titleStarRating,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(widget.sellerId)
                      .get()
                      .then((snap) {
                    //seller not yet receive rating from any user

                    if (snap.data()!["ratings"] == null) {
                      FirebaseFirestore.instance
                          .collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": countStarsRating.toString(),
                      });
                    }
                    //seller has already received rating from any user
                    else {
                      double pastRatings =
                          double.parse(snap.data()!["ratings"].toString());
                      double newRatings = (pastRatings + countStarsRating) / 2;
                      FirebaseFirestore.instance
                          .collection("sellers")
                          .doc(widget.sellerId)
                          .update({
                        "ratings": newRatings.toString(),
                      });
                    }
                    Fluttertoast.showToast(msg: "Rated Successfully.");
                    setState(() {
                      countStarsRating = 0.0;
                      titleStarRating = "";
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const MySplashScreen()));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                ),
                child: const Text("Submit"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
