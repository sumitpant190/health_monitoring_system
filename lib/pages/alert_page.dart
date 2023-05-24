import 'package:flutter/material.dart';

class HealthDataDisplay extends StatefulWidget {
  const HealthDataDisplay({super.key});

  @override
  HealthDataDisplayState createState() => HealthDataDisplayState();
}

class HealthDataDisplayState extends State<HealthDataDisplay> {
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _data = [
    {
      'dateTime': DateTime.now().subtract(const Duration(days: 2)),
      'maxHeartRate': 80,
      'minHeartRate': 72,
      'maxTemperature': 98.6,
      'minTemperature': 97.5
    },
    {
      'dateTime': DateTime.now().subtract(const Duration(days: 1)),
      'maxHeartRate': 82,
      'minHeartRate': 74,
      'maxTemperature': 99.1,
      'minTemperature': 97.7
    },
    {
      'dateTime': DateTime.now(),
      'maxHeartRate': 86,
      'minHeartRate': 76,
      'maxTemperature': 99.5,
      'minTemperature': 98.1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_data[index]['dateTime'].year}-${_data[index]['dateTime'].month}-${_data[index]['dateTime'].day} ${_data[index]['dateTime'].hour}:${_data[index]['dateTime'].minute}:${_data[index]['dateTime'].second}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Max Heart Rate: ${_data[index]['maxHeartRate']} bpm',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Min Heart Rate: ${_data[index]['minHeartRate']} bpm',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Max Temperature: ${_data[index]['maxTemperature']}°F',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Min Temperature: ${_data[index]['minTemperature']}°F',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
