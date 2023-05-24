//import 'dart:async';

//import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class OxygenSaturation extends StatefulWidget {
  const OxygenSaturation({super.key});

  @override
  State<OxygenSaturation> createState() => _OxygenSaturationState();
}

class _OxygenSaturationState extends State<OxygenSaturation> {
  late String oxygenSaturation = '95';
  final databaseReference = FirebaseDatabase.instance.ref('5166519');
  // databaseReference = FirebaseDatabase.instance.ref(activeDeviceID);
  var timer;
  @override
  void initState() {
    //oxygenSaturation = "0";
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    //  var deviceWidth = MediaQuery.of(context).size.width;
    setState(() {});
    return Scaffold(
        appBar: AppBar(
          title: const Text("Oxygen Saturation"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 15, 0, 77),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: (() {
                    setState(() {
                      print('set state');
                      //  startUpdatingData();
                    });
                  }),
                  child: const Icon(Icons.health_and_safety)),
              StreamBuilder(
                stream: readData(),
                builder: (context, snapshot) {
                  return SizedBox(
                    width: deviceHeight / 4.5,
                    height: deviceHeight / 4.5,
                    child: SleekCircularSlider(
                      // min: 0,
                      //maximum heartrate
                      max: double.parse(oxygenSaturation) > 240
                          ? double.parse(oxygenSaturation)
                          : 240,
                      innerWidget: (percentage) {
                        return Center(
                          child: Text(
                            oxygenSaturation + " %",
                            style: TextStyle(
                                fontSize: deviceHeight / 35,
                                color: Colors.orange,
                                fontWeight: FontWeight.w800),
                          ),
                        );
                      },
                      appearance: CircularSliderAppearance(
                          angleRange: 240,
                          customColors: CustomSliderColors(
                              dotColor: Colors.white,
                              progressBarColors: [
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),
                                Colors.orange,
                                Colors.orange,
                                Colors.orange,
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 17, 0),

                                //  Colors.orange,
                              ],
                              trackColors: [
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 98, 87),
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 98, 87),
                                Colors.orange,
                                const Color.fromARGB(255, 255, 17, 0),
                                const Color.fromARGB(255, 255, 98, 87),
                              ]),
                          customWidths: CustomSliderWidths(
                              progressBarWidth: 15, handlerSize: 4)),

                      //control the circle using this initialvalue
                      //from setstate or other builder
                      //i am keeping dummy value as 130 for now
                      initialValue: double.parse(oxygenSaturation),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  readData() {
    int heart = 0, temp = 0;
    try {
      databaseReference.onValue.listen((DatabaseEvent event) {
        Map data = event.snapshot.value as Map;
        temp = int.parse(data['TEMP_VALUE']);
        heart = int.parse(data['HEART_VALUE']);

        if ((heart >= 40 && heart <= 100) && (temp >= 34 && temp <= 37.5)) {
          oxygenSaturation = "97";
        } else if ((heart >= 101 && heart <= 109) &&
            (temp > 37.5 && temp <= 38)) {
          oxygenSaturation = "95 ";
        } else if ((heart >= 110 && heart <= 130) &&
            (temp > 38 && temp <= 39)) {
          oxygenSaturation = "93";
        } else if ((heart > 130) && (temp > 39)) {
          oxygenSaturation = "91";
        } else {
          oxygenSaturation = "Measuring..";
        }

        setState(() {
          print(oxygenSaturation);
        });
      });
      // ignore: empty_catches
    } catch (error) {}
  }

  void startUpdatingData() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      readData();
    });
  }
}
