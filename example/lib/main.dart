import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_introduction_tooltip/flutter_introduction_tooltip.dart';
import 'package:rect_getter/rect_getter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  String _platformVersion = 'Unknown';
  GlobalKey globalKey = RectGetter.createGlobalKey();
  bool isShowing = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void showTutorial(BuildContext context) async {
    if (!isShowing) {
      new Timer(Duration(milliseconds: 100), () async {
        try {
          FlutterIntroductionTooltip.showTopTutorialOnWidget(
              context,
              globalKey,
              Colors.blue,
                  () => Navigator.pop(context),
              "MAMA",
              "MAMA IS A LOREM IPSUM",
              "ALRIGHT");
          print("SHOWING");
          setState(() {
            isShowing = true;
          });
        } catch (e) {
          print("ERROR $e");
        }
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterIntroductionTooltip.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    showTutorial(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
            builder: (BuildContext context) {
              showTutorial(context);
              return Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomRight,
                child: Text(
                  'Running on: $_platformVersion\n',
                  key: globalKey,
                ),
              );
            }
        ),
      ),
    );
  }
}
