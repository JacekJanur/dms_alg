import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int jobsNumber = 3;
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

  List<Map<String, int>> jobs =[{
    'p': 0,
    'd': 0,
    'T': 0,
  },
    {
      'p': 0,
      'd': 0,
      'T': 0,
    },
    {
      'p': 0,
      'd': 0,
      'T': 0,
    },
    {
      'p': 0,
      'd': 0,
      'T': 0,
    },
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
                for (var i in indexesTime)
                  Column(children: [Text(i.toString())]),
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
                  Column(children: [Text(jobs[i-1]['p'].toString())]),
                ]
              ],
            ),
            TableRow(
              children: [
                Column(children: [Text('d')]),
                for (int i = 1; i <= jobsNumber; i++) ...[
                  Column(children: [Text(jobs[i-1]['d'].toString())]),
                ]
              ],
            ),
            TableRow(
              children: [
                Column(children: [Text('T')]),
                for (int i = 1; i <= jobsNumber; i++) ...[
                  Column(children: [Text(jobs[i-1]['T'].toString())]),
                ]
              ],
            ),
          ],
        );
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
        OutlinedButton(onPressed: () {
          setState(() {
            jobs = getJobs(jobsNumber, maxTime, minTime);
          });
        }, child: Text("Losuj zadnia")),
        OutlinedButton(onPressed: () {}, child: Text("Start"))
      ],
    );
  }
}

List<Map<String,int>> getJobs(n, max, min)
{
  List<Map<String, int>> jobs =[];
  Random random = new Random();
  int p=0;
  int d=0;
  int T=0;

  for(int i=0; i<n; i++)
    {
      p = (random.nextInt(max+1-min) + min).toInt();
      d = p + random.nextInt(max+5);
      T = (random.nextInt(10)+p).toInt();

      jobs.add({
        'p': p,
        'd': d,
        'T': T,
      });
    }

  return jobs;
}