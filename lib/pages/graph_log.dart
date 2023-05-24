import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  @override
  void initState() {
    presentDate = getCurrentDate();
    generateTimeStamps();
    checkForNodeID();

    // testFirebase();
    super.initState();
  }

  late List<DropdownMenuItem<String>> dropDownMenuItems = [
    const DropdownMenuItem(
      value: 'item1',
      child: Text('No VALUE'),
    ),
  ];
  late String _selectedValue = dropDownMenuItems[0].value!;
  String _selectedVitalValue = 'Heart';
  DateTime currentDate = DateTime.now();
  String presentDate = "";
  late double deviceHeight;
  late double deviceWidth;

  int firstPointer = 0;
  int lastPointer = 8;
  bool isLoading = false;

  List<Map<String, dynamic>> graphData = List.empty(growable: true);
  List<FlSpot> graphPlotData = List.empty(growable: true);
  // List<String> xAxisTimeStampData = List.empty(growable: true);
  // List<double> max_min = [0, 0];
  List<String> xAxisTimeStampData = List.empty(growable: true);
  double maxHeartRate = 0;
  double minHeartRate = 0;
  String vitalToMeasure = "HEART_MEASURE";

  double minY = 40;
  double maxY = 120;
  String? activeDeviceID;
  late final databaseReference;

  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat(' MMMM d, y');
    return formatter.format(now);
  }

  String formattedDate(DateTime now) {
    var formatter = DateFormat(' MMMM d, y');
    return formatter.format(now);
  }

  generateTimeStamps() {
    var currentTime = DateTime.now();
    for (int i = 0; i < 9; i++) {
      var pastTime = currentTime.subtract(Duration(seconds: i));
      xAxisTimeStampData.add(
          "${pastTime.hour.toString().padLeft(2, '0')}:${pastTime.minute.toString().padLeft(2, '0')}:${pastTime.second.toString().padLeft(2, '0')}");
    }
  }

//date picker using calender action

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        //after we press oke then we are setting state to do something
        //in this case we are simply changing value of a text widget
        .then((value) => {
              if (value != null)
                {
                  setState(
                    () {
                      //null safety ! mark
                      graphData = List.empty(growable: true);

                      graphPlotData = List.empty(growable: true);
                      currentDate = value;
                      presentDate = formattedDate(currentDate);
                      //  print("after formation");
                      try {
                        isLoading = true;
                        _loadData();
                        //    log("dropdown created");
                        //  fetchDataFromFirebase();
                        //  findLowestAndHighest();
                        //   log("fetched data");
                        // addCoordinates();
                        //   log("coordinates added");
                        // addCoordinates();
                      } catch (error) {
                        log(error.toString());
                      }
                      // addCoordinates();
                    },
                  )
                }
            });
  }

  //
  checkForNodeID() async {
    // List<String> nodeID = List.empty(growable: true);
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
            _loadData();
            //  readData();
            //   print(activeDeviceID);
            // Get.to(() => NavBarPage(
            //       currentActiveId: activeDeviceID,
            //     ));
          }

          // log("error");
        }
      }

      // log("Statement copleted totally");
    } catch (error) {
      // print("No Such Data");
    }
    // log(activeDeviceID);

    //log(userID);
    return activeDeviceID;
  }

  _loadData() async {
    int count = 0;

    final user = FirebaseAuth.instance.currentUser;
    try {
      log(presentDate);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('Nodes')
          .doc(activeDeviceID)
          .collection(presentDate)
          .doc(vitalToMeasure)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map data = documentSnapshot.data() as Map;
          dropDownMenuItems = List.empty(growable: true);
          data.forEach((key, value) {
            count++;

            dropDownMenuItems.add(DropdownMenuItem(
              value: value,
              child: Text(value),
            ));
            //  print(value);
            log(count.toString());
          });
          Future.delayed(const Duration(seconds: 3));

          _selectedValue = dropDownMenuItems[0].value!;
          fetchDataFromFirebase();
        } else {
          isLoading = false;
          Text('No Data');
          print('Document does not exist on the database');
        }
      });
    } catch (error) {
      log(error.toString());
    }
    // log("finished loading data");
  }

  addCoordinates() {
    // print(graphData);
    String tempValue;
    String tempTimeStamp;
    int count = 0;
    for (int i = 8; i >= 0; i--) {
      //  log("before pushing value");
      tempValue = graphData[count]['value'];
      tempTimeStamp = graphData[count]['time_stamp'];
      //  log("after pushing value");
      //  print(tempValue);
      graphPlotData.add(FlSpot(i.toDouble(), double.parse(tempValue)));

      xAxisTimeStampData.add(tempTimeStamp);

      count++;
    }
    for (int i = 0; i < 9; i++) {
      xAxisTimeStampData.removeAt(0);
    }
    // print(xAxisTimeStampData);
    // setState(() {
    //   isLoading = false;
    // });
  }

  leftSwipeHandler() {
    List<FlSpot> tempSpot = List.empty(growable: true);
    List<String> tempxAxisTimeStampData = List.empty(growable: true);

    int count = 8;
    firstPointer--;
    lastPointer--;
    for (int i = firstPointer; i <= lastPointer; i++) {
      tempSpot
          .add(FlSpot(count.toDouble(), double.parse(graphData[i]['value'])));

      tempxAxisTimeStampData.add(graphData[i]['time_stamp']);
      count--;
    }

    graphPlotData = [];
    xAxisTimeStampData = [];
    setState(() {
      graphPlotData = tempSpot;
      xAxisTimeStampData = tempxAxisTimeStampData;
      tempxAxisTimeStampData = [];
      tempSpot = [];
    });
  }

  rightSwipeHandler() {
    List<FlSpot> tempSpot = List.empty(growable: true);
    List<String> tempxAxisTimeStampData = List.empty(growable: true);
    int count = 8;
    firstPointer++;
    lastPointer++;
    for (int i = firstPointer; i <= lastPointer; i++) {
      tempSpot
          .add(FlSpot(count.toDouble(), double.parse(graphData[i]['value'])));
      tempxAxisTimeStampData.add(graphData[i]['time_stamp']);

      count--;
    }
    graphPlotData = [];
    xAxisTimeStampData = [];
    setState(() {
      graphPlotData = tempSpot;
      xAxisTimeStampData = tempxAxisTimeStampData;
      tempxAxisTimeStampData = [];
      tempSpot = [];
    });

    // double tempValue = 0;
    // int count = 0;
    // graphPlotData.removeAt(0);
    // for (int i = 8; i > 0; i--) {
    //   tempValue = graphPlotData[count].y;
    //   tempSpot.add(FlSpot(i.toDouble(), tempValue));
    //   count++;
    // }
    // tempSpot.add(FlSpot(0, graphData[graphData_index_pointer]['value']));
    // graphPlotData = List.empty(growable: true);
    // graphPlotData = tempSpot;
    // graphData_index_pointer++;
    // print(graphPlotData);
  }

  findLowestAndHighest() {
    // print("Inside high low function");
    // List<double> max_min = [];

    double lowest = double.parse(graphData[0]['value'] ?? "");
    double highest = double.parse(graphData[0]['value'] ?? "");

    for (int i = 0; i < graphData.length; i++) {
      String valueString = graphData[i]['value'] ?? "";
      double value = double.parse(valueString);
      if (value < lowest) {
        lowest = value;
      }
      if (value > highest) {
        highest = value;
      }
    }

    setState(() {
      maxHeartRate = highest;
      minHeartRate = lowest;
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: const Text(
          'Logs',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                _showDatePicker();
              },
              child: const Icon(
                Icons.calendar_month,
                color: Colors.black,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //current date
                Text(presentDate),
                // DropdownButton(items: items, onChanged: onChanged),
                DropdownButton(
                  value: _selectedVitalValue,
                  items: const [
                    DropdownMenuItem(
                      value: 'Heart',
                      child: Text('Heart'),
                    ),
                    DropdownMenuItem(
                      value: 'Temperature',
                      child: Text('Temperature'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      graphData = List.empty(growable: true);
                      graphPlotData = List.empty(growable: true);
                      _selectedVitalValue = value!;
                      if (_selectedVitalValue == 'Heart') {
                        vitalToMeasure = "HEART_MEASURE";
                        minY = 40;
                        maxY = 120;
                      } else {
                        vitalToMeasure = "TEMP_MEASURE";
                        minY = 0;
                        maxY = 40;
                      }
                      //fetchDataFromFirebase();
                      _loadData();
                    });
                  },
                ),
                DropdownButton(
                  value: _selectedValue,
                  items: dropDownMenuItems,
                  onChanged: (value) {
                    //  print(graphData);
                    setState(() {
                      //reset the pointer values
                      //when new session is pressed from the dropdown
                      firstPointer = 0;
                      lastPointer = 8;
                      _selectedValue = value!;
                      graphData = List.empty(growable: true);

                      try {
                        fetchDataFromFirebase();
                      } catch (error) {
                        log(error.toString());
                      }

                      // addCoordinates();
                      //   print(value);
                    });
                  },
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth / 35, right: deviceWidth / 20),
              child: Container(
                height: deviceHeight / 2,
                width: deviceWidth,
                color: Colors.white,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    //  log(details.delta.dx.toString());
                    try {
                      if (details.delta.dx < 0) {
                        // User swiped left
                        //   log("LEFT LEFT LEFT LEFT");
                        if (firstPointer > 0 && details.delta.dx < -4.0) {
                          leftSwipeHandler();
                        }
                      } else {
                        //swipe right
                        // log("RIGHT RIGHT RIGHT RIGHT");
                        if (lastPointer < graphData.length - 1 &&
                            details.delta.dx > 4) {
                          rightSwipeHandler();
                        }

                        //  log(graphData.length.toString());
                      }
                    } catch (error) {
                      log(error.toString());
                    }
                  },
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 15, 0, 77),
                        ))
                      : LineChart(
                          LineChartData(
                              //the minimum and maximum value of this chart should be dynamic
                              //we shall receive data from the database and accordingly change
                              //the minimum and maximum range of values

                              minX: 0,
                              maxX: 8,
                              minY: minY,
                              maxY: maxY,
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
                                  color: const Color.fromARGB(255, 248, 18, 2),
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
                                  dotData: FlDotData(show: true),
                                  barWidth: 2.0,
                                  spots: graphPlotData,

                                  // ],
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
                                //   bottomTitles: mainData(),
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
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                  reservedSize: deviceHeight / 25,
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return customStyleText("");
                                      case 1:
                                        return customStyleText(
                                            xAxisTimeStampData[7]);
                                      case 2:
                                        return customStyleText(
                                            xAxisTimeStampData[6]);

                                      case 3:
                                        return customStyleText(
                                            xAxisTimeStampData[5]);
                                      case 4:
                                        return customStyleText(
                                            xAxisTimeStampData[4]);
                                      case 5:
                                        return customStyleText(
                                            xAxisTimeStampData[3]);
                                      case 6:
                                        return customStyleText(
                                            xAxisTimeStampData[2]);
                                      case 7:
                                        return customStyleText(
                                            xAxisTimeStampData[1]);
                                      case 8:
                                        return customStyleText(
                                            xAxisTimeStampData[0]);

                                      default:
                                        return customStyleText("");
                                    }
                                  },
                                )),
                              )),
                        ),
                ),
              ),
            ),

            //graph

            //heart range, highest heart range, lowest heart range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text('Vital  range'),
                        // Text(
                        //   '76-104  times/min',
                        //   style: TextStyle(
                        //       color: Colors.black, fontWeight: FontWeight.bold),
                        // )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Highest $_selectedVitalValue: $maxHeartRate'),
                        Text('Lowest $_selectedVitalValue: $minHeartRate'),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  fetchDataFromFirebase() async {
    graphPlotData = List.empty(growable: true);

    // log(_selectedValue.toString());
    final user = FirebaseAuth.instance.currentUser;
    try {
      QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .collection('Nodes')
          .doc(activeDeviceID)
          .collection(presentDate)
          .doc(vitalToMeasure)
          .collection(_selectedValue.toString())
          .orderBy('time_stamp', descending: true)
          .get();
      if (query.docs.isEmpty) {
        log("no data");
      } else {
        for (var doc in query.docs) {
          graphData
              .add({'time_stamp': doc['time_stamp'], 'value': doc['value']});

          //    xAxisTimeStampData.add(doc['time_stamp']);

          // log("error");
        }
        //    print(xAxisTimeStampData);

        // print(graphData);
        // log("graph data");
        setState(() {
          addCoordinates();

          findLowestAndHighest();
          isLoading = false;
        });
      }
      // ignore: empty_catches
    } catch (error) {}
    //  log("fetching function completed");
  }

  Text customStyleText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'VisbyRound',
          fontSize: deviceHeight / 90),
    );
  }
}
