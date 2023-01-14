import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({super.key});

  @override
  State<LogsWidget> createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _selectedValue;

  void _loadData() {
    _dropDownMenuItems = [
      DropdownMenuItem(
        value: 'item1',
        child: Text('Item 1'),
      ),
      DropdownMenuItem(
        value: 'item2',
        child: Text('Item 2'),
      ),
      DropdownMenuItem(
        value: 'item3',
        child: Text('Item 3'),
      ),
    ];
    _selectedValue = _dropDownMenuItems[0].value!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: Text(
          'Logs',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.calendar_month,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //current date
              Text('Current Date'),
              // DropdownButton(items: items, onChanged: onChanged),
              DropdownButton(
                value: _selectedValue,
                items: _dropDownMenuItems,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20,
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
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Heart rate range'),
                      Text(
                        '76-104  times/min',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Highest heart rate: '),
                      Text('Lowest heart rate: '),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
