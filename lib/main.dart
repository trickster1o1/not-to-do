import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String data = '';
  List lists = [];
  final ntdText = TextEditingController();

  final LocalStorage storage = LocalStorage('todo');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red[800],
            title: const Center(child: Text('Not To Do')),
          ),
          body: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  lists = storage.getItem('notTodo');
                });
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 300.0,
                              height: 50.0,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  hintText: 'Add Something Not To Do',
                                ),
                                controller: ntdText,
                                onChanged: (value) {
                                  setState(() {
                                    data = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      lists = [
                                        ...lists,
                                        {
                                          'title': data,
                                          'id': lists.length + 1,
                                          'status': 'pending'
                                        }
                                      ];
                                    });
                                    storage.setItem('notTodo', lists);
                                    ntdText.clear();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red[800]),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: const Icon(Icons.add)),
                            ),
                          ],
                        )),
                  ),
                  const Divider(
                    color: Colors.red,
                  ),
                  Expanded(
                    child: ListView(
                      children: lists == null
                          ? [
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: SpinKitPouringHourGlassRefined(
                                    color: Colors.red,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ]
                          : lists
                              .map((e) => GestureDetector(
                                    onPanUpdate: (details) {
                                      if (details.delta.dx < 0) {
                                        setState(() {
                                          lists.remove(e);
                                        });
                                        storage.setItem('ntdList', lists);
                                      } else {
                                        if (lists[e['id'] - 1]['status'] ==
                                            'pending') {
                                          setState(() {
                                            lists[e['id'] - 1]['status'] =
                                                'success';
                                          });
                                          storage.setItem('ntdList', lists);
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          color: Colors.red,
                                        ),
                                      )),
                                      child: ListTile(
                                        leading: Icon(e['status'] == 'success'
                                            ? Icons.check_circle
                                            : Icons.circle_outlined),
                                        title: Text(e['title']),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    child: lists != null && lists.length > 0
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                lists.clear();
                              });
                              storage.setItem('ntdList', lists);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[700]),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text('Clear List'),
                          )
                        : const SizedBox(),
                  ),
                  // Text(storage.getItem('notTodo')[0]['title'] ??
                  //     'You\'ve got nothing to not do'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
