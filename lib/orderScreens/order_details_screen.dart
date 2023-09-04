import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/orderScreens/address_design_widget.dart';
import 'package:users_app/orderScreens/status_banner_widget.dart';

import '../models/address.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatefulWidget {
  String? orderID;

  OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, AsyncSnapshot datasnapshot) {
            Map? orderDataMap;
            if (datasnapshot.hasData) {
              orderDataMap = datasnapshot.data.data() as Map<String, dynamic>;
              orderStatus = orderDataMap["status"].toString();

              return Column(
                children: [
                  StatusBanner(
                    status: orderDataMap["isSuccess"],
                    orderStatus: orderStatus,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${orderDataMap["totalAmount"]} MMK",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order ID = ${orderDataMap["orderId"]}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order at = ${DateFormat("dd MMMM, yyyy -  hh: mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDataMap["orderTime"])))}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 4,
                    color: Colors.pinkAccent,
                  ),
                  orderStatus == "ended"
                      ? Image.asset("images/delivered.png")
                      : Image.asset("images/state.png"),
                  const Divider(
                    thickness: 4,
                    color: Colors.pinkAccent,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(orderDataMap["addressID"])
                        .get(),
                    builder: (c, AsyncSnapshot dataSnapshot) {
                      if (dataSnapshot.hasData) {
                        return AddressDesign(
                          model: Address.fromJson(
                              dataSnapshot.data.data() as Map<String, dynamic>),
                          orderStatus: orderStatus,
                          orderId: widget.orderID,
                          sellerId: orderDataMap!["sellerUID"],
                          orderByUser: orderDataMap["orderBy"],
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No data exists.",
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("No dat exist."),
              );
            }
          },
        ),
      ),
    );
  }
}
