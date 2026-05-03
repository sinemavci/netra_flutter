import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'dart:async';
import 'package:netra_flutter/netra_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class DataList {
  final List<Data> list;

  DataList(this.list);
}

class Data {
  final String name;
  Data(this.name);
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final netraClient = await NetraClient.build(
        baseUrl: "http://10.0.2.2:3001", convertedType: ConverterType.gson);

    final result = await netraClient.get("/?status=200&delay=1000");
    print("result in main: ${result?.data}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        // body: Center(
        //   child: Text('Running on: $_platformVersion\n'),
        // ),
      ),
    );
  }
}
