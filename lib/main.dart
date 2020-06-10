import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String internet = "Internet Check";

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Connected!');
      }
    } on SocketException catch (_) {
      print('Not Connected!');
    }
  }

  checkConnectivity() async {
    final result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      print('Not Connected!');
    } else if (result == ConnectivityResult.wifi) {
      print('Connected to WIFI');
    } else if (result == ConnectivityResult.mobile) {
      print('Connected to Mobile');
    }
  }

  StreamSubscription _subscription;
  ConnectivityResult isInternet;

  checkConnectivityListener() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print('Not Connected!');
        setState(() {
          internet = 'Not Connected!';
        });
      } else if (isInternet == ConnectivityResult.none) {
        print('Connected');
        setState(() {
          internet = 'Connected!';
        });
      }

      setState(() {
        isInternet = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectivityListener();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Internet Check"),
        ),
        body: Container(
          color:
              isInternet == ConnectivityResult.none ? Colors.red : Colors.white,
          child: Center(
            child: Text(internet),
          ),
        ),
      ),
    );
  }
}
