import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/sellersScreens/home_screen.dart';
import 'package:users_app/widgets/custom_text_field.dart';
import 'package:users_app/widgets/loading_dialog.dart';

import '../global/global.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  validateFrom() {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      //allow user to login
      loginNow();
    } else {
      Fluttertoast.showToast(msg: "Please provide email and password.");
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialogWidget(
          message: "Checking credidential",
        );
      },
    );

    User? currentUser;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
    });

    if (currentUser != null) {
      checkIfUserRecordExist(currentUser!);
    }
  }

  checkIfUserRecordExist(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      if (record.exists) // record exist
      {
        //status is approve
        if (record.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);
          await sharedPreferences!
              .setString("photoUrl", record.data()!["photoUrl"]);

          // ignore: unused_local_variable
          List<String> userCartList = record.data()!["userCart"].cast<String>();
          await sharedPreferences!.setStringList("userCart", userCartList);
          // send user to home screen
          // ignore: use_build_context_synchronously
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        } else //status is not approved
        {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  "You have BLOCKED by admin. \nContact Admin Email: admin@fillup.com");
        }
      } else //record no exist
      {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "This record do not exists.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "images/login.png",
              height: MediaQuery.of(context).size.height * 0.40,
            ),
          ),
          Form(
            key: formkey,
            child: Column(
              children: [
                //email
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  iconData: Icons.email,
                  hintText: "Email",
                  isObsecure: false,
                  enabled: true,
                ),

                //pass
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.lock,
                  hintText: "Password",
                  isObsecure: true,
                  enabled: true,
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
            onPressed: () {
              validateFrom();
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
