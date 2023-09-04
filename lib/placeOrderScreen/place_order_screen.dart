import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:users_app/global/global.dart';
import 'package:users_app/sellersScreens/home_screen.dart';

// ignore: must_be_immutable
class PlaceOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlaceOrderScreen({
    super.key,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  orderDetails() {
    saveOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderId,
      "orderId": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
    }).whenComplete(() {
      saveOrderDetailsForSeller({
        "addressID": widget.addressID,
        "totalAmount": widget.totalAmount,
        "orderBy": sharedPreferences!.getString("uid"),
        "productIDs": sharedPreferences!.getStringList("userCart"),
        "paymentDetails": "Cash on Delivery",
        "orderTime": orderId,
        "orderId": orderId,
        "isSuccess": true,
        "sellerUID": widget.sellerUID,
        "status": "normal",
      }).whenComplete(() {
        cartMethods.clearCart(context);
        //send push notification to seller about new order which placed by user
        sendNotificationToSeller(
          widget.sellerUID.toString(),
          orderId,
        );

        Fluttertoast.showToast(
            msg: "Congratulations! Order has benn placed successfully.");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));

        orderId = "";
      });
    });
  }

  saveOrderDetailsForUser(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(orderDetailsMap);
  }

  sendNotificationToSeller(sellerUID, orderID) {
    String sellerDeviceToken = "";

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["sellerDeviceToken"] != null) {
        sellerDeviceToken = snapshot.data()!["sellerDeviceToken"].toString();
        print("Device Token of that Seller = " + sellerDeviceToken);
        print("Device Token of that Seller = " + orderID);
      }
    });

    notificationFormat(
      sellerDeviceToken,
      orderID,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(sellerDeviceToken, orderID, userName) {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };

    Map bodyNotification = {
      'body':
          "Dear seller, New Order (# $orderID) has placed Successfully from user $userName. \nPlease Check Now",
      'title': "New Order",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": orderID,
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': sellerDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/delivery.png"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              orderDetails();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              "Place Order Now",
            ),
          ),
        ],
      ),
    );
  }
}
