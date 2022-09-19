import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// import 'package:http/http.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'dart:convert';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      FlutterNativeSplash.remove();
    });
  }

  String data = '';
  List lists = [];

  // Future<dynamic> getWeather() async {
  //   Response response = await get(Uri.parse(
  //       'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=67a4d79ec9f4d69744fc00df2310bc01'));
  //   Map res = jsonDecode(response.body);
  //   print(res);
  //   print('====loc======');
  //   var something = _getGeoLocationPosition();
  //   print(something);
  // }

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
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, .2))),
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
                                          'status': false
                                        }
                                      ];
                                    });
                                    storage.setItem('notTodo', lists);
                                    ntdText.clear();
                                    FocusScope.of(context).unfocus();
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
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        e['status'] = !e['status'];
                                      });
                                      storage.setItem('ntdList', lists);
                                    },
                                    onDoubleTap: () {
                                      setState(() {
                                        lists.remove(e);
                                      });
                                      storage.setItem('ntdList', lists);
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        data = e['title'];
                                      });
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text(
                                                    'Update Not To Do'),
                                                content: TextFormField(
                                                  initialValue: e['title'],
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(15.0),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      data = value;
                                                    });
                                                  },
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        e['title'] = data;
                                                      });
                                                      storage.setItem(
                                                          'ntdList', lists);
                                                      FocusScope.of(context)
                                                          .unfocus();

                                                      Navigator.pop(
                                                          context, 'OK');
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ));
                                    },
                                    // splashColor: Colors.red,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          color: Colors.red,
                                        ),
                                      )),
                                      child: ListTile(
                                        leading: Icon(e['status']
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
