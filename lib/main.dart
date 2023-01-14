import 'package:flutter/material.dart';
import 'package:health_monitoring_system/pages/homepage.dart';
import 'package:health_monitoring_system/pages/notifications_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}
