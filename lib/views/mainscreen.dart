import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Main Screen"),
      actions: [
        GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => const UserLoginPage());
            },
            child: const Icon(Icons.logout))
      ],
    ));
  }
}
