import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/dms.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int jobsNumber = 4;
  int maxTime = 10;
  int minTime = 0;
  List<int> indexesTime = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20
  ];

  List<Map<String, int>> jobs = [
    {
      'id': 0,
      'p': 1,
      'd': 1,
      'T': 2,
    },
    {
      'id': 1,
      'p': 1,
      'd': 3,
      'T': 4,
    },
    {
      'id': 2,
      'p': 2,
      'd': 8,
      'T': 10,
    },
    {
      'id': 3,
      'p': 1,
      'd': 10,
      'T': 10,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PropertiesInputs(),
          _JobsInfoTable(),
          _JobsTimeTable(),
        ],
      ),
    );
  }

  Table _JobsTimeTable() {
    return Table(
      children: [
        TableRow(
          children: [
            Column(children: [Text('s')]),
            for (var i in indexesTime) Column(children: [Text(i.toString())]),
          ],
        ),
        TableRow(
          children: [
            TableCell(child: Text('Z')),
            for (var i in indexesTime)
              TableCell(
                child: Container(
                  child: Text(''),
                  color: i % 2 == 0 ? Colors.red : Colors.orange,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Table _JobsInfoTable() {
    return Table(
      border: TableBorder.all(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 1,
      ),
      children: [
        TableRow(
          children: [
            Column(children: [Text('')]),
            for (int i = 1; i <= jobsNumber; i++) ...[
              Column(children: [Text('Z ${i}')]),
            ]
          ],
        ),
        TableRow(
          children: [
            Column(children: [Text('p')]),
            for (int i = 1; i <= jobsNumber; i++) ...[
              InkWell(
                  //onTap: () {showEditDialog(context, jobs[i - 1]['p']!, 1, i-1);},
                onTap: (){
                  _editVariable(i, 'p');
                },
                  child: Column(children: [Text(jobs[i - 1]['p'].toString())])),
            ]
          ],
        ),
        TableRow(
          children: [
            Column(children: [Text('d')]),
            for (int i = 1; i <= jobsNumber; i++) ...[
              InkWell(
                  onTap: (){
                    _editVariable(i, 'd');
                  },
                  child: Column(children: [Text(jobs[i - 1]['d'].toString())])),
            ]
          ],
        ),
        TableRow(
          children: [
            Column(children: [Text('T')]),
            for (int i = 1; i <= jobsNumber; i++) ...[
              InkWell(
                  onTap: (){
                    _editVariable(i, 'T');
                  },
                  child: Column(children: [Text(jobs[i - 1]['T'].toString())])),
            ]
          ],
        ),
      ],
    );
  }

  Future<dynamic> _editVariable(int i, String zmienna) {
    return showDialog(
                    context: context,
                    builder: (context) {
                        final myController = TextEditingController();

                        @override
                        void dispose() {
                          // Clean up the controller when the widget is disposed.
                          myController.dispose();
                          super.dispose();
                        }
                        return AlertDialog(
                          content: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: myController,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    decoration:
                                    InputDecoration(hintText: jobs[i-1][zmienna].toString()),
                                  ),
                                ],
                              )),
                          title: Text('Zmien wartosc'),
                          actions: <Widget>[
                            InkWell(
                              onTap: (){Navigator.of(context).pop();},
                              child: Text('Anuluj', style: TextStyle(color: Colors.red),),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  jobs[i-1][zmienna] = int.parse(myController.text);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Zmien'),
                            ),
                          ],
                        );

                    });
  }

  Row _PropertiesInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Liczba zadań: "),
        SizedBox(
          width: 50,
          child: TextFormField(
            onChanged: (value) {
              try {
                int tmp = int.parse(value);
                if (tmp > 0 && tmp < 10) {
                  setState(() {
                    jobsNumber = tmp;
                    jobs = getJobs(jobsNumber, maxTime, minTime);
                  });
                }
              } on Exception catch (_) {
                print('not int');
              }
            },
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Text("Maksymalny czas zadania: "),
                SizedBox(
                    width: 50,
                    child: TextFormField(
                      onChanged: (value) {
                        try {
                          int tmp = int.parse(value);
                          if (tmp > 0 && tmp < 10) {
                            setState(() {
                              maxTime = tmp;
                              jobs = getJobs(jobsNumber, maxTime, minTime);
                            });
                          }
                        } on Exception catch (_) {
                          print('not int');
                        }
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Minimalny czas zadania: "),
                SizedBox(
                    width: 50,
                    child: TextFormField(
                      onChanged: (value) {
                        try {
                          int tmp = int.parse(value);
                          if (tmp > 0 && tmp < 10) {
                            setState(() {
                              minTime = tmp;
                              jobs = getJobs(jobsNumber, maxTime, minTime);
                            });
                          }
                        } on Exception catch (_) {
                          print('not int');
                        }
                      },
                    )),
              ],
            ),
          ],
        ),
        OutlinedButton(
            onPressed: () {
              setState(() {
                jobs = getJobs(jobsNumber, maxTime, minTime);
              });
            },
            child: Text("Losuj zadnia")),
        OutlinedButton(onPressed: () {
          print(dms(jobs));
        }, child: Text("Start"))
      ],
    );
  }
}

List<Map<String, int>> getJobs(n, max, min) {
  List<Map<String, int>> jobs = [];
  Random random = new Random();
  int p = 0;
  int d = 0;
  int T = 0;

  for (int i = 0; i < n; i++) {
    p = (random.nextInt(max + 1 - min) + min).toInt();
    d = p + random.nextInt(max + 5);
    T = (random.nextInt(10) + d).toInt();

    jobs.add({
      'id': i,
      'p': p,
      'd': d,
      'T': T,
    });
  }

  return jobs;
}


