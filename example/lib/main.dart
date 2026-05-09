import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'dart:async';
import 'package:netra_flutter/netra_flutter_plugin.dart';
import 'package:image_picker/image_picker.dart';

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
  }

  Future<void> handleGet() async {
    final netraClient = await NetraClient.build(
        baseUrl: "http://10.0.2.2:3001", convertedType: ConverterType.gson);

    final result = await netraClient.get(url: "/?status=200&delay=1000",
      requestOptions: RequestOptions(
        offlinePolicyAction: OfflinePolicyAction.retry(retries: 3),
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );
    print("result in main: ${result?.statusCode}  statusMessage ${result?.statusMessage} data: ${result?.data}");
  }

  Future<void> handlePost() async {
    final netraClient = await NetraClient.build(
        baseUrl: "https://jsonplaceholder.typicode.com",
        convertedType: ConverterType.kotlinX);

    final result = await netraClient.post(url: "/users",
      body: RequestBody.createBytes(Uint8List.fromList(
          utf8.encode(jsonEncode({'name': 'Sinem', 'job': 'developer'}))),
      ),
      // body: RequestBody.createJson(jsonEncode({'name': 'Sinem', 'job': 'developer'})),
      requestOptions: RequestOptions(
        offlinePolicyAction: OfflinePolicyAction.retry(retries: 3),
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );
    print("result in main: ${result?.statusCode}  statusMessage ${result
        ?.statusMessage} data: ${result?.data}");
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
      imageQuality: 85, // optional: compress (0–100)
    );

    if (file != null) {
      final Uint8List bytes = await file.readAsBytes();
      final netraClient = await NetraClient.build(
          baseUrl: "https://jsonplaceholder.typicode.com",
          convertedType: ConverterType.kotlinX);

      final requestBodyPart = RequestBodyPart.file(name: "image",
          fileName: "exampleImage",
          bytes: bytes,
          contentType: "image/jpeg");
      final requestBody = RequestBody.multipart([requestBodyPart]);

      final result = await netraClient.post(url: "/users",
        body: requestBody,
        requestOptions: RequestOptions(
          offlinePolicyAction: OfflinePolicyAction.retry(retries: 3),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
        ),
      );
      print("result in main: ${result?.statusCode}  statusMessage ${result
          ?.statusMessage} data: ${result?.data}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children:[
            ElevatedButton(onPressed: handleGet, child: Text('get',)),
            ElevatedButton(onPressed: handlePost, child: Text('post',)),
            ElevatedButton(onPressed: pickImage, child: Text('post image',))
          ]
        ),
      ),
    );
  }
}
