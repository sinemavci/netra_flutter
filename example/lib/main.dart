import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/enums/offline_policy_action.dart';
import 'package:netra_flutter/common/enums/slow_network_policy_action.dart';
import 'package:netra_flutter/common/models/circuit_breaker_options.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/observers/client_event.dart';
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

String? eventId;


void callback1(String key, int ageMs, int ttlMs, int expiredByMs) {
  print("cache expired: key $key ageMs $ageMs ttlMs $ttlMs expiredByMs $expiredByMs");
}


void callback2(String key, int ageMs, int ttlMs, int expiredByMs) {
  print("cache stolen used: key $key ageMs $ageMs ttlMs $ttlMs expiredByMs $expiredByMs");
}


  Future<void> handleGet() async {
    final netraClient = await NetraClient.build(
      headers: {
        "here": "heree"
      },
      baseUrl: "http://10.0.2.2:3001",
      convertedType: ConverterType.gson,
      circuitBreakerOptions: CircuitBreakerOptions(),
    );

    netraClient.on(CacheEvent.cacheExpired(callback1));
    netraClient.on(CacheEvent.cacheMiss((key) {
      print("cache missed");
    }));

    netraClient.on(CacheEvent.cacheStored((key, a, b) {
      print("cache stored: ${a} ${b}");
    }));

    eventId = netraClient.on(CacheEvent.cacheStaleUsed(callback2));

    final result = await netraClient.get(url: "/?status=200&delay=1000",
      requestOptions: RequestOptions(
        offlinePolicyAction: OfflinePolicyAction.useCache,
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );

    print(
        "result in main: ${jsonEncode(result?.headers)}  statusMessage ${result
            ?.statusMessage} data: ${result?.data}");

    // Future.delayed(Duration(seconds: 15), () {
    //   if (eventId != null) {
    //     netraClient.off(eventId!);
    //   }
    // });
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

  Future<void> handlePut() async {
    final netraClient = await NetraClient.build(
        baseUrl: "https://jsonplaceholder.typicode.com",
        convertedType: ConverterType.kotlinX);

    final result = await netraClient.put(url: "/users/1",
      body: RequestBody.createBytes(Uint8List.fromList(
          utf8.encode(jsonEncode({'name': 'Sinem', 'job': 'mobile developer'}))),
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

  Future<void> handleDelete() async {
    final netraClient = await NetraClient.build(
        baseUrl: "https://jsonplaceholder.typicode.com",
        convertedType: ConverterType.kotlinX);

    final result = await netraClient.delete(url: "/users/1",
      requestOptions: RequestOptions(
          offlinePolicyAction: OfflinePolicyAction.retry(retries: 3),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
          headers: {
            "custom": "sinem here",
          }
      ),
    );
    print("result in main:  headers: ${jsonEncode(result?.headers)}  statusMessage ${result
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
            ElevatedButton(onPressed: pickImage, child: Text('post image',)),
            ElevatedButton(onPressed: handlePut, child: Text('put',)),
            ElevatedButton(onPressed: handleDelete, child: Text('delete',))
          ]
        ),
      ),
    );
  }
}
