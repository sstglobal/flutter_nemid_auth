import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nemid_auth/nemid_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _response;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    await NemId.setNemIdEndpoints(
      signing: "",
      validation: "",
      isDev: true,
    );
    String response;

    try {
      response = await NemId.authWithNemID;
    } on PlatformException {
      response = null;
    }

    if (!mounted || response == null) return;

    print("response $response");

    setState(() {
      _response = jsonDecode(response);
    });
  }

  String getResult() {
    String result = "";

    if (_response != null) {
      if (_response.containsKey("status")) {
        result += "Status: ${_response['status']}\n";
      }

      if (_response.containsKey("result")) {
        result += "Result: ${_response['result']}\n";
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NemID Login'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: initPlatformState,
                child: Text("Login"),
              ),
              Text(
                getResult(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
