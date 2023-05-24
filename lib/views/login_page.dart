import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/nav_bar_page.dart';
import 'chip_id_page.dart';
import 'forget.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  TextEditingController loginemailController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();

  //this boolean condition is set to true on the begin of a function execution that is of type Future where aysnc is used
  //it will be set to false when function has finished execution
  //this is used to show a circularporgressindicator when the function is being executed and show real widget or data when function finishes executing
  bool _isLoading = false;

  bool _hidePassword = true;
  Stream<QuerySnapshot>? snapshotStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 0, 77),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Login Screen"),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color.fromARGB(255, 15, 0, 77),
              ))
            : SingleChildScrollView(
                child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  height: 300.0,
                  child: Lottie.asset("assets/63787-secure-login.json"),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: loginemailController,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 15, 0, 77),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 15, 0, 77),
                          ),
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        obscureText: _hidePassword,
                        controller: loginpasswordController,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 15, 0, 77),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Color.fromARGB(255, 15, 0, 77),
                          ),
                          suffixIcon: _hidePassword
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.visibility,
                                    color: Color.fromARGB(255, 15, 0, 77),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(255, 15, 0, 77),
                                  ),
                                ),
                          hintText: 'Password',
                          enabledBorder: const OutlineInputBorder(),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    var loginemail = loginemailController.text.trim();
                    var loginpassword = loginpasswordController.text.trim();
                    try {
                      final User? firebaseUser = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: loginemail, password: loginpassword))
                          .user;

                      if (firebaseUser != null) {
                        //check if the user already owns a device
                        _checkForNodeID();

                        //    Get.to(() => NavBarPage());
                      }
                    } on FirebaseAuthException catch (error) {
                      alertDialogshowerOnFirebaseException(
                          error.code.toString());

                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                    return const Color.fromARGB(255, 15, 0, 77);
                  })),
                  child: const Text("Login"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => const Forgetscreen());
                    },
                    style: ButtonStyle(backgroundColor:
                        MaterialStateColor.resolveWith(
                            (Set<MaterialState> states) {
                      return const Color.fromARGB(255, 255, 17, 0);
                    })),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot Password",
                        //  style: TextStyle(backgroundColor: Colors.white),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.to(() => const Signup());
                    },
                    style: ButtonStyle(backgroundColor:
                        MaterialStateColor.resolveWith(
                            (Set<MaterialState> states) {
                      return const Color.fromARGB(255, 15, 0, 77);
                    })),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dont have an account? SignUp",
                        //  style: TextStyle(backgroundColor: Colors.white),
                      ),
                    )),
              ])));
  }

  Future<void> _checkForNodeID() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .collection('Nodes')
          .get();

      if (query.docs.isEmpty) {
        log("no data");
        setState(() {
          _isLoading = false;
        });
        Get.to(() => const ChipIDValidator());
      } else {
        for (var doc in query.docs) {
          // nodeID.add(doc['myid']);
          //   print(doc["active"]);
          if (doc['active'] == "true") {
            setState(() {
              _isLoading = false;
            });
            Get.to(() => const NavBarPage());
          }

          // log("error");
        }
      }

      // log("Statement copleted totally");
      // ignore: empty_catches
    } catch (error) {}
    // log(activeDeviceID);

    //log(userID);
  }

  alertDialogshowerOnFirebaseException(String errorCode) {
    // log(errorCode);
    switch (errorCode) {
      case 'wrong-password':
        returnAlertDialogOnError("Email or Password Incorrect");
        break;

      case 'unknown':
        returnAlertDialogOnError("Please Fill The Fields Correctly");
        break;

      case 'user-not-found':
        returnAlertDialogOnError("Email or Password Incorrect");
        break;
      case 'email-already-in-use':
        // log("Custom: The email is already used");
        // Code to handle the error
        returnAlertDialogOnError(
            'The email address is already in use by another account');
        // FocusScope.of(context).requestFocus(_focusNode);
        break;

      case 'invalid-email':
        returnAlertDialogOnError("Enter a valid email address");
        break;
      case 'weak-password':
        break;
      //default: errorDialog.returnAlertDialogOnError(context, errorCode); log("Default case ran"); break;
    }
  }

  returnAlertDialogOnError(String textValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(textValue),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return const Color.fromARGB(255, 15, 0, 77);
              })),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
