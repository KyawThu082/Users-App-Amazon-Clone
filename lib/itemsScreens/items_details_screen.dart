import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/widgets/appbar_cart_badge.dart';

import '../global/global.dart';
import '../models/items.dart';

// ignore: must_be_immutable
class ItemsDetailsScreen extends StatefulWidget {
  Items? model;

  ItemsDetailsScreen({super.key, this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  int counterLimit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(
        sellersUID: widget.model!.sellerUID.toString(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int itemCounter = counterLimit;

          List<String> itemIDsList =
              cartMethods.seperateItemIDsFromUserCartList();
          //1. check if item exist already in cart
          if (itemIDsList.contains(widget.model!.itemID)) {
            Fluttertoast.showToast(msg: "Item is already in Cart");
          } else {
            //2. add item in cart
            cartMethods.addItemToCart(
              widget.model!.itemID.toString(),
              itemCounter,
              context,
            );
          }
        },
        label: const Text(
          "Add to Cart",
        ),
        icon: const Icon(
          Icons.add_shopping_cart_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.model!.thumbnailUrl.toString(),
            ),

            // implemant the item counter
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CartStepper(
                  // ignore: deprecated_member_use
                  count: counterLimit,
                  size: 50,
                  style: const CartStepperStyle(
                      backgroundColor: Colors.red,
                      activeBackgroundColor: Colors.pinkAccent,
                      activeForegroundColor: Colors.white),
                  didChangeCount: (value) {
                    if (value < 1) {
                      Fluttertoast.showToast(
                          msg: "The quantity cannot be less than 1");

                      return;
                    }

                    setState(() {
                      counterLimit = value;
                    });
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "${widget.model!.itemTitle}:",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${widget.model!.price} MMK",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 320.0),
              child: Divider(
                height: 1,
                thickness: 2,
                color: Colors.pinkAccent,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
