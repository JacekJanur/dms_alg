import 'dart:ffi';
import 'dart:math';
import 'package:dms_alg/utils/check_initial_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/dms.dart';
import '../utils/get_jobs.dart';
import '../utils/variables.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int jobsNumber = 4;
  int maxTime = 10;
  int minTime = 0;
  bool calculated = false;


  List<Map<String, dynamic>> scheduledJobs = [];

  List<Map<String, int>> jobs = PublicVariables().jobsStarter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _PropertiesInputs()),
          Expanded(child: _JobsInfoTable()),
          if(calculated) _JobsTimeTable(),
          if(calculated) Text('LCM: ${DMS().getLcm(jobs)}'),
        ],
      ),
    );
  }

  Widget _JobsTimeTable() {
    return scheduledJobs != [] ? Expanded(
        child: SingleChildScrollView(
          child: Container(
            height: 200,
            width: double.maxFinite,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Table(
                  defaultColumnWidth: FixedColumnWidth(60.0),
                  children: [
                    TableRow(
                      children: [
                        Column(children: [Text('s')]),
                        for (var i = 1; i <= scheduledJobs.length; i++) Column(children: [Text(i.toString())]),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(child: Text('Z', textAlign: TextAlign.center,)),
                        for (var i = 0; i < scheduledJobs.length; i++)
                          TableCell(
                            child: Container(
                              alignment: Alignment.center,
                              child: (scheduledJobs[i]['id']!=-1) ? Text(scheduledJobs[i]['id'].toString()) : Text("P", style: TextStyle(color: Colors.red)),
                              color: (scheduledJobs[i]['id']!=-1) ? PublicVariables().colorsList[scheduledJobs[i]['id']] : Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    ):
        const Center(child: Text("test"),);

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
              Container(
                  color: PublicVariables().colorsList[i-1],
                  child: Column(children: [Text('Z ${i-1}')])),
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
          dynamic test = jobs;
          test = DMS().calculateDMS(test);
          if(checkInitialValues(jobs))
            {
              setState(() {
                calculated = true;
                scheduledJobs = test;
              });
            }
          else{
            showDialog(context: context, builder:
            (context) => AlertDialog(content: Text("Złe wartości zadań")),);
          }
        }, child: Text("Start"))
      ],
    );
  }
}




