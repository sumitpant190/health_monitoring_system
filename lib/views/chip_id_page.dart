import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../pages/nav_bar_page.dart';

class ChipIDValidator extends StatefulWidget {
  const ChipIDValidator({super.key});

  @override
  State<ChipIDValidator> createState() => _ChipIDValidatorState();
}

class _ChipIDValidatorState extends State<ChipIDValidator> {
  late double deviceHeight;
  late double deviceWidth;
  late String chipID;
  TextEditingController hardwareIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: deviceWidth,
            height: deviceHeight,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //animation
                SizedBox(
                  // alignment: Alignment.center,
                  height: deviceHeight / 4,
                  child: Lottie.asset("assets/cpu_chip.json"),
                ),
                SizedBox(
                  // color: Color.fromARGB(255, 255, 35, 35),
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Enter Your Hardware ID",
                            style: TextStyle(
                                fontFamily: 'VisbyRound',
                                fontSize: deviceHeight / 30),
                          ),
                          SizedBox(
                            height: deviceHeight / 55,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                              controller: hardwareIdController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                // /  prefixIcon: Icon(Icons.search),
                                suffixIcon: const Icon(
                                  Icons.sd_card,
                                  color: Colors.grey,
                                ),
                                hintText: "Hardware ID",
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'QuickSand',
                                    fontSize: 17.0),
                                filled: true,
                                fillColor: Colors.white,
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                contentPadding: const EdgeInsets.all(16.0),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        width: 2.0)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight / 40,
                          ),
                          SizedBox(
                            width: 150.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.black),
                              ),
                              onPressed: () {
                                _checkForHardwareID();
                              },
                              child: const Text('Verify'),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _checkForHardwareID() async {
    final user = FirebaseAuth.instance.currentUser;
    bool hardwareExists = false;
    try {
      QuerySnapshot<Map<String, dynamic>> query =
          await FirebaseFirestore.instance.collection('NodeID').get();

      if (query.docs.isEmpty) {
        log("no data");
        //  CircularProgressIndicator();
      } else {
        for (var doc in query.docs) {
          // nodeID.add(doc['myid']);
          //   print(doc["active"]);
          if (doc['id'] == hardwareIdController.text) {
            hardwareExists = true;
          }
          // log("error");
        }
      }
      if (hardwareExists) {
        log("hardware  exists");
//create document nodes with hardware id and set 2 param
//1 hardware id as my id itself and othe parameter as active
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .collection("Nodes")
            .doc(hardwareIdController.text)
            .set({
          'myid': hardwareIdController.text,
          'active': "true",
        }).then((value) => {
                  Get.to(() => const NavBarPage()),
                });
      } else {
        log("hardware does not exists");
      }
      // ignore: empty_catches
    } catch (error) {}
  }
}
