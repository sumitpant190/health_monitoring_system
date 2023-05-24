import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import './graph_plot.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int trackHeartStatus = 0;
  late double deviceHeight;
  late double deviceWidth;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 15, 0, 77),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //circe avatar and options
                Padding(
                  padding: EdgeInsets.only(
                      top: deviceHeight / 18,
                      left: deviceWidth / 25,
                      right: deviceWidth / 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: deviceHeight / 43.35),
                        child: CircleAvatar(
                          //  foregroundImage: Text(""),
                          radius: deviceHeight / 27,
                          child: Text(
                            "S",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontFamily: "VisbyRound",
                                fontWeight: FontWeight.bold,
                                fontSize: deviceHeight / 25),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Get.off(() => LoginPage());
                              },
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight / 40,
                ),

                //Date and Hello
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth / 16.45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "2022-01-01",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: "VisbyRound",
                        ),
                      ),
                      SizedBox(height: deviceHeight / 144),
                      Text(
                        'Hello, Sumit!',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "VisbyRound",
                            fontSize: deviceHeight / 35),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight / 28.9,
                ),
              ],
            ),
            // vitals container
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //     //  topLeft: Radius.circular(40),
                  //     // topRight: Radius.circular(40),
                  //     ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: deviceWidth / 21.675),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: deviceHeight / 28.9),
                      Text(
                        'How are you feeling?',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "VisbyRound",
                            fontWeight: FontWeight.bold,
                            fontSize: deviceHeight / 40),
                      ),
                      SizedBox(
                        height: deviceHeight / 28.9,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //heart rate
                          GestureDetector(
                            onTap: () {
                              //this will take us to new hraph_plot page with parameters like heart or temp
                              //in this case heart string is passed, as we need to display similar icons
                              //and retrive heart data
                              //when we come back from live_graph plot, the trackHeartStatus will be set to 0 or 1
                              // 1 indicating keep log of my heart in background

                              //final trackHeartStatus =
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RealTimeGraphRenderer("HEART"),
                                ),
                              );

                              if (trackHeartStatus == 0) {
                                //set RT database value to 2
                              } else if (trackHeartStatus == 1) {
                                //keep tracking and dont set realtime database value to 0

                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 63, 29),
                                    borderRadius: BorderRadius.circular(20)),
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Padding(
                                  padding: EdgeInsets.all(deviceHeight / 34.68),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/white-heart.png',
                                            height: deviceHeight / 35,
                                            // width: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: deviceWidth / 55),
                                          Text(
                                            'Heart Rate',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "VisbyRound",
                                                fontWeight: FontWeight.w800,
                                                fontSize: deviceHeight / 43),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        'assets/icons/heart.png',
                                        color: Colors.grey[200],
                                      ),
                                      SizedBox(
                                        height: deviceHeight / 43.35,
                                      ),
                                      Text(
                                        '85 bpm',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "VisbyRound",
                                            fontWeight: FontWeight.w600,
                                            fontSize: deviceHeight / 25),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              //temperature
                              GestureDetector(
                                onTap: () {
                                  //   final trackTempStatus =
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RealTimeGraphRenderer("TEMP"),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(deviceHeight / 108),
                                  child: Container(
                                    height: deviceHeight * 0.2,
                                    width: deviceWidth * 0.4,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 153, 1),
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight / 28.9)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(deviceHeight / 86.7),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: deviceHeight / 86.7),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Image.asset(
                                                'assets/icons/celsius.png',
                                                color: Colors.white,
                                                height: deviceHeight / 28.9,
                                              ),
                                              Text(
                                                'Temperature',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "VisbyRound",
                                                    fontWeight: FontWeight.w800,
                                                    fontSize:
                                                        deviceHeight / 50),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: deviceHeight / 35),
                                            child: Center(
                                              child: Text(
                                                '37 °C',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "QuickSand",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        deviceHeight / 25),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              //oxygen saturation
                              GestureDetector(
                                onTap: () {
                                  print(
                                      "GO to new page and show only saturation");
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceHeight / 108.375),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: Colors.orange[800],
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight / 43.35)),
                                    child: Column(
                                      children: [
                                        SizedBox(height: deviceHeight / 35),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      deviceHeight / 21.675),
                                            ),
                                            Image.asset(
                                              'assets/icons/sp02.png',
                                              width: deviceWidth / 8,
                                              height: deviceHeight / 15,
                                            ),
                                          ],
                                        ),

                                        //  SizedBox(height: 10),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              deviceHeight / 108.375),
                                          child: Text(
                                            '96%',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "QuickSand",
                                                fontWeight: FontWeight.w800,
                                                fontSize: deviceHeight / 25),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )

                      //vitals containers
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
