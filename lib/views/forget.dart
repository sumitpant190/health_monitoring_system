import 'dart:developer';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Forgetscreen extends StatefulWidget {
  const Forgetscreen({super.key});

  @override
  State<Forgetscreen> createState() => ForgetscreenState();
}

class ForgetscreenState extends State<Forgetscreen> {
  TextEditingController forgetController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 0, 77),
          centerTitle: true,
          title: const Text("Forget Screen"),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: 300.0,
            child: Lottie.asset("assets/75988-forgot-password.json"),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: forgetController,
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
          ElevatedButton(
              onPressed: () async {
                var forgetEmail = forgetController.text.trim();
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: forgetEmail)
                      .then((value) => {
                            log("Email sent"),
                            Get.off(() => const UserLoginPage()),
                          });
                } on FirebaseAuthException catch (error) {
                  log(error.toString());
                }
              },
              style: ButtonStyle(backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return const Color.fromARGB(255, 15, 0, 77);
              })),
              child: const Text("Send Link To Email  ")),
          const SizedBox(
            height: 10,
          ),
        ])));
  }
}
