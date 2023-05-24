// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: "Plots Live graph",
    home: RealTimeGraphRenderer("Heart"),
    debugShowCheckedModeBanner: false,
  ));
}

class RealTimeGraphRenderer extends StatefulWidget {
  @override
  final Key? key;
  final String vital;

  const RealTimeGraphRenderer(this.vital, {this.key});
  @override
  State<StatefulWidget> createState() {
    return RealTimeGraphRendererState();
  }
}

class RealTimeGraphRendererState extends State<RealTimeGraphRenderer> {
//constructor for future use
  RealTimeGraphRendererState();

  late final databaseReference;

  List<FlSpot> heartSpots = List.empty(growable: true);
  late double deviceHeight;
  late double deviceWidth;
  String status = "0";
  var timer;

  double dynamicMinY = 40;
  double dynamicMaxY = 180;
  double heartRate = 0;

  String? vitalToMeasure;

  bool _isTracking = false;
  bool _startMeasuring = false;
  String? activeDeviceID;

  late String param;

  TextEditingController sessionNameController = TextEditingController();
  @override
  void initState() {
    //  generateCoordinatesHeart();
    param = widget.vital;
    if (param == "TEMP") {
      vitalToMeasure = "TEMP_MEASURE";
      param = "℃";
    } else if (param == "HEART") {
      vitalToMeasure = "HEART_MEASURE";
      param = "bpm";
    } else if (widget.vital == "OXYGEN") {
      param == "Oxygen Saturation";
    }
    checkForNodeID();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        heartSpots = List<FlSpot>.empty();
        try {
          databaseReference
              .update({"NUM": 0}).then((value) => {log("sucessfully set 0")});
        } catch (error) {}

        // setState(() {});
        //  databaseReference.;
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            height: deviceHeight,
            width: deviceWidth,
            child: Padding(
              padding: EdgeInsets.only(top: deviceHeight / 20),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: deviceHeight / 4.5,
                      height: deviceHeight / 4.5,
                      child: SleekCircularSlider(
                        // min: 0,
                        //maximum heartrate
                        max: double.parse(status) > 240
                            ? double.parse(status)
                            : 240,
                        innerWidget: (percentage) {
                          return Center(
                            child: Text(
                              "$status $param",
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
                        initialValue: double.parse(status),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            // widget.vital=="HEART"?(Icons.heart_broken):Icons(Icons.temple_buddhist),
                            widget.vital == "HEART"
                                ? const Icon(Icons.monitor_heart)
                                : const Icon(Icons.thermostat),
                            Text(!_startMeasuring
                                ? "Start Measuring ${widget.vital}"
                                : "Stop Measuring ${widget.vital}"),

                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _startMeasuring = !_startMeasuring;
                                });

                                // startUpdatingData();
                                //  if(this.)
                                try {
                                  if (!_startMeasuring) {
                                    databaseReference.update({"NUM": 0});
                                    return;
                                  }

                                  if (widget.vital == "HEART") {
                                    log("1");
                                    databaseReference.update({"NUM": 2});
                                    log("11");
                                  } else if (widget.vital == "TEMP") {
                                    //log(2);
                                    databaseReference.update({"NUM": 1});
                                    //   log(22);
                                  } else if (widget.vital == "OXYGEN") {
                                    databaseReference.update({"NUM": 3});
                                  }
                                } catch (error) {}

                                //  readData();
                              }),
                              child: CircleAvatar(
                                radius: deviceHeight / 36,
                                backgroundColor: Colors.deepOrange,
                                child: Icon(
                                  !_startMeasuring
                                      ? Icons.play_arrow
                                      : Icons.pause_circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: deviceWidth / 14,
                        ),
                        Column(
                          children: [
                            StreamBuilder(
                              builder: (context, snapshot) {
                                return Text("Start Tracking Status: $status");
                              },
                            ),
                            CupertinoSwitch(
                              value: _isTracking,
                              onChanged: (value) {
                                // returnSessionAlertDialog();

                                if (!_isTracking) {
                                  //   print('tracking')
                                  returnSessionAlertDialog();
                                  //   _uploadDataToFirebase();
                                } else {
                                  _isTracking = false;

                                  log("Switch is off");
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight / 35,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth / 35, right: deviceWidth / 30),
                      child: Container(
                        height: deviceHeight / 2,
                        width: deviceWidth,
                        color: Colors.white,
                        child: LineChart(
                          LineChartData(
                              //the minimum and maximum value of this chart should be dynamic
                              //we shall receive data from the database and accordingly change
                              //the minimum and maximum range of values

                              minX: 0,
                              maxX: 8,
                              minY: 0,
                              maxY: param == "bpm" ? 180 : 50,
                              //  minY: widget.vital == "HEART" ? 40 : 0,
                              // maxY: widget.vital == "HEART" ? 120 : 40,
                              borderData: FlBorderData(
                                  show: true,
                                  border: const Border(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    left: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  )),
                              gridData: FlGridData(
                                drawVerticalLine: true,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.2),
                                    dashArray: [2, 2, 2],
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(
                                    color: Colors.black.withOpacity(0.05),
                                    dashArray: [2, 2, 2],
                                  );
                                },
                              ),

                              //backgroundColor: Colors.black,
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                  // gradient: const LinearGradient(
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: [
                                  //     Colors.amber,
                                  //     Colors.red,
                                  //     Color.fromARGB(255, 238, 15, 175)
                                  //   ],
                                  // ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    //color: Colors.red.withOpacity(0.2),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(60, 255, 17, 0),
                                        Color.fromARGB(60, 255, 255, 255),
                                        // Colors.red,
                                        // Color.fromARGB(255, 238, 15, 175)
                                      ],
                                    ),
                                  ),
                                  dotData: FlDotData(show: false),
                                  barWidth: 2.0,
                                  spots: heartSpots,
                                ),
                              ],
                              titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                                  rightTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: false, reservedSize: 0)),
                                  bottomTitles: mainData(),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                    reservedSize: deviceWidth / 17,
                                    interval: 10,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: deviceHeight / 60,
                                            fontFamily: 'VisbyRound',
                                            fontWeight: FontWeight.bold),
                                      );
                                    },
                                  )))),
                        ),
                      ),
                    ),
                    xAxisLabelCOntainer(),
                  ]),
            ),
          ),
        ),
      )),
    );
  }

  void readData() async {
    //alertFunctions alert = alertFunctions();
    print("first execution");
    try {
      databaseReference.onValue.listen((DatabaseEvent event) {
        Map data = event.snapshot.value as Map;
        if (widget.vital == "HEART") {
          print("second execution");
          status = data['HEART_VALUE'];
          print(status);
          //  int tempDelete = int.parse(status);
          // log(tempDelete.toString());
          // if (tempDelete > 120) {
          //   log("exceeded");
          //   uploadAlertToFirebase(status, 'heart');
          // }
          // uploadAlertToFirebase(status, 'heart');
          print("third execution");

          //  heartAlerts(int.parse(status));
          //uploadAlertToFirebase(status, 'h');
          //alert.heartAlerts(status);
        } else if (widget.vital == "TEMP") {
          status = data['TEMP_VALUE'];
          int tempDelete = int.parse(status);
          log(tempDelete.toString());
          if (tempDelete > 38) {
            log("temp exceeded");
            uploadAlertToFirebase(status, 'temp');
          }
          //alert.tempAlerts(status);
        }

        if (_isTracking) {
          _uploadDataToFirebase();
        }

        // if (status == 1) {
        //   vibrateMyPhone();
        // }
//create a function to push every points back to one position back
//heartSpots.add(FlSpot(7, double.parse(status)));
        pushListGraphCoordinates();

        setState(() {});

        // updateStarCount(data);
      });
    } catch (error) {}
    print(status);
  }

  AxisTitles mainData() {
    return AxisTitles(
        sideTitles: SideTitles(
      reservedSize: deviceHeight / 25,
      showTitles: true,
      getTitlesWidget: (value, meta) {
        switch (value.toInt()) {
          case 0:
            return customStyleText("");
          case 1:
            return customStyleText("7");
          case 2:
            return customStyleText("6");

          case 3:
            return customStyleText("5");
          case 4:
            return customStyleText("4");
          case 5:
            return customStyleText("3");
          case 6:
            return customStyleText("2");
          case 7:
            return customStyleText("1");
          case 8:
            return customStyleText("RT");

          default:
            return customStyleText("");
        }
      },
    ));
  }

  //function to generte specific color text for button or any datats
  Text customStyleText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'VisbyRound',
          fontSize: deviceHeight / 50),
    );
  }

  Container xAxisLabelCOntainer() {
    return Container(
      //  alignment: Alignment.bottomCenter,
      height: 21,
      //width: 45,
      color: Colors.transparent,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          width: 50,
          child: Icon(
            Icons.arrow_back,
            // size: 25,
          ),
        ),
        Text(
          "Time In Seconds",
          style: TextStyle(
              fontFamily: 'QuickSand',
              fontSize: deviceHeight / 55,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.timer_rounded,
          color: Color.fromARGB(255, 164, 164, 164),
        )
      ]),
    );
  }

//future functions to retrive realtime data from database

//fow now i shall use random number generator

  void pushListGraphCoordinates() {
    try {
      var tempListHeart = List<FlSpot>.empty(growable: true);
      // int tempI = 0;

      for (int i = 0; i < heartSpots.length; i++) {
        //   tempI++;

        //  print(tempListHeart[i]);
        double tempY = 0;
        tempY = heartSpots[i].x - 1;
        tempListHeart.add(FlSpot(tempY, heartSpots[i].y));
      }

      double tempLastHeartbeat = double.parse(status);

      heartRate = tempLastHeartbeat;

      tempListHeart.add(FlSpot(8, tempLastHeartbeat.toDouble()));
      dynamicMaxY = (tempLastHeartbeat / 10).ceil() * 10 + 10;
      // dynamicMinY = (tempLastHeartbeat / 10).ceil() * 10 - 10;

      if (tempListHeart.length > 9) {
        while (tempListHeart.length > 9) {
          tempListHeart.removeAt(0);
        }
      }

      heartSpots = tempListHeart;

      tempListHeart = List<FlSpot>.empty(growable: true);
    } catch (error) {}
  }

  void startUpdatingData() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      var tempListHeart = List<FlSpot>.empty(growable: true);

//gettng y values from the list FLspot
//now we shall create a new list from his values
//and add a new value at index 10
      int tempI = 0;
      for (int i = 0; i < 7; i++) {
        tempI++;
        tempListHeart.add(FlSpot(i.toDouble(), heartSpots[tempI].y));
      }
      double tempLastHeartbeat = double.parse(status);
      heartRate = tempLastHeartbeat;
      tempListHeart.add(FlSpot(8, tempLastHeartbeat.toDouble()));

      // dynamicMaxY = (tempLastHeartbeat / 10).ceil() * 10+ 50;
      // dynamicMinY = (tempLastHeartbeat / 10).ceil() * 10- 50;

      heartSpots = tempListHeart;
      // Redraw the graph
      setState(() {});
    });
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {});
  }

  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat(' MMMM d, y');
    return formatter.format(now);
  }

  String getCurrentHrsSeconds() {
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm:ss');
    return formatter.format(now);
  }

  _setSessionName() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .collection("Nodes")
          .doc(activeDeviceID)
          .collection(getCurrentDate())
          .doc(vitalToMeasure)
          .set({
        sessionNameController.text.trim(): sessionNameController.text.trim(),
      });
    } catch (error) {
      log(error.toString());
    }
  }

  _uploadDataToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .collection("Nodes")
          .doc(activeDeviceID)
          .collection(getCurrentDate())
          .doc(vitalToMeasure)
          .collection(sessionNameController.text.trim())
          .doc()
          .set({
        'time_stamp': getCurrentHrsSeconds(),
        'value': status,
      }).then((value) => {
                log("value saved"),
              });
    } catch (error) {}
  }

  returnSessionAlertDialog() {
    bool validate = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Name Your Session'),
          content: TextField(
            controller: sessionNameController,
            decoration: InputDecoration(
              // labelText: 'Enter your username',
              errorText: !validate ? "Please Give A Name" : null,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  // width: 250,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red),
                    ),
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  // width: 250,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.green),
                    ),
                    child: const Text("Save"),
                    onPressed: () {
                      log("save button pressed");
                      if (sessionNameController.text == '') {
                        //is text empty
                        log("If statement");
                        log("Empty text");
                        validate = false;
                      } else {
                        log("else statement");
                        validate = true;
                        _isTracking = true;
                        _setSessionName();
                        // _uploadDataToFirebase();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Future<void> play() async {
  //   // All 'play' requests from all origins route to here. Implement this
  //   // callback to start playing audio appropriate to your app. e.g. music.
  // }

  // Future<void> stop() async {}

  checkForNodeID() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .collection('Nodes')
          .get();

      if (query.docs.isEmpty) {
        //  Get.to(() => ChipIDValidator());
        log("No Chip IDdata present");
      } else {
        for (var doc in query.docs) {
          // nodeID.add(doc['myid']);
          //   print(doc["active"]);
          if (doc['active'] == "true") {
            activeDeviceID = doc['myid'];
            databaseReference = FirebaseDatabase.instance.ref(activeDeviceID);
            readData();
            // Get.to(() => NavBarPage(
            //       currentActiveId: activeDeviceID,
            //     ));
          }

          // log("error");
        }
      }

      // log("Statement copleted totally");
    } catch (error) {}
    // log(activeDeviceID);

    //log(userID);
    return activeDeviceID;
  }

  uploadAlertToFirebase(String data, String type) async {
    print("alerts provoked");
    final user = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .collection("Nodes")
          .doc(5166519.toString())
          .collection(getCurrentDate())
          .doc('Alerts')
          .collection('Alert')
          .doc()
          .set({
        'time_stamp': getCurrentHrsSeconds(),
        'data': data,
        'type': type,
      }).then((value) => {
                print("alerts saved"),
              });
    } catch (error) {
      print(error);
    }
  }
}
