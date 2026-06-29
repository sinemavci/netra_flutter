import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:netra_flutter/common/exceptions/base_platform_exception.dart';
import 'package:netra_flutter/common/observers/cache_event.dart';
import 'package:netra_flutter/common/observers/queue_event.dart';
import 'package:netra_flutter/common/observers/request_event.dart';
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
  StreamController<Uint8List> imageStream = StreamController();


  void callback1(RequestOptions request, int ageMs, int ttlMs, int expiredByMs) {
    print(
        "cache expired: key ${request.url} ageMs $ageMs ttlMs $ttlMs expiredByMs $expiredByMs");
  }


  void callback2(RequestOptions request, int ageMs, int ttlMs, int expiredByMs) {
    print(
        "cache stolen used: key ${request.url} ageMs $ageMs ttlMs $ttlMs expiredByMs $expiredByMs");
  }

  final netraClient = NetraClient(
    baseUrl: "http://10.0.2.2:3001",
    headers: {
      "Authorization": "Bearer token"
    },
    converterType: ConverterType.gson,
    // circuitBreakerOptions: CircuitBreakerOptions(),
  );

  Future<void> handleGet() async {
    netraClient.on(RequestEvent.requestExecuted((request) {
      print(
          "request executed: request: ${request.url} ${request.body?.content}");
    }));
    netraClient.on(RequestEvent.requestSuccess((request, response) {
      print("request success: request: ${request.url} ${request.body
          ?.content} -- response: ${response.data}");
    }));
    netraClient.on(RequestEvent.requestFailed((request, response) {
      print("request failed: request: ${request.url} ${request.body
          ?.content} -- response: ${response?.statusCode}");
    }));
    netraClient.on(CacheEvent.cacheExpired(callback1));
    netraClient.on(CacheEvent.cacheMiss((key) {
      print("cache missed");
    }));

    netraClient.on(CacheEvent.cacheStored((key, a, b) {
      print("cache stored: ${a} ${b}");
    }));

    netraClient.on(QueueEvent.requestQueued((key, a, b) {
      print("requestQueued: $key ${a} ${b}");
    }));

    netraClient.on(QueueEvent.queuedRequestRestored((key) {
      print("queuedRequestRestored: $key");
    }));

    netraClient.on(QueueEvent.queuedRequestExecuted((key, response) {
      print(
          "queuedRequestExecuted: $key response${response.statusCode} ${response
              .data}");
    }));


    eventId = netraClient.on(CacheEvent.cacheStaleUsed(callback2));

    netraClient.on(CacheEvent.cacheStored((request, a, b) {
      print("cache stored: ${request.offlinePolicyAction?.identifier}");
    }));

    try {
      final result = await netraClient.get(
        requestOptions: RequestOptions(
          url: "/?status=200&delay=4000",
          offlinePolicyAction: OfflinePolicyAction.queue,
          cancelOnDispose: true,
          slowNetworkPolicyAction: SlowNetworkPolicyAction.timeout(
              timeout: Duration(milliseconds: 2000)),
        ),
      );
      print(
          "result in main: ${jsonEncode(result?.headers)}  statusMessage ${result
              ?.statusMessage} data: ${result?.data}");
    } on NetraConnectionException catch (e) {
      print("get connection exception on main:${e.message}");
    }


    // Future.delayed(Duration(seconds: 15), () {
    //   if (eventId != null) {
    //     netraClient.off(eventId!);
    //   }
    // });
  }

  Future<void> handleGetImage() async {
    final result = await netraClient.getStream(
      requestOptions: RequestOptions(
        url: "/image",
        cancelOnDispose: true,
        offlinePolicyAction: OfflinePolicyAction.queue,
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );
    final List<int> imageBytes = [];

    result.listen(
          (data) {
        print("data in main: ${data}");
        imageBytes.addAll(data);
      },
      onDone: () {
        imageStream.add(Uint8List.fromList(imageBytes));
        print("image completed");
      },
      onError: (e) {
        print("stream error $e");
      },
    );
  }

  Future<void> handlePost() async {
    final netraClient = NetraClient(
        baseUrl: "https://jsonplaceholder.typicode.com",
        converterType: ConverterType.kotlinX);

    final result = await netraClient.post(
      // body: RequestBody.createJson(jsonEncode({'name': 'Sinem', 'job': 'developer'})),
      requestOptions: RequestOptions(
        url: "/users",
        body: RequestBody.createJson(jsonEncode({'name': 'Sinem', 'job': 'developer'})),
        // body: RequestBody.createBytes(Uint8List.fromList(
        //     utf8.encode(jsonEncode({'name': 'Sinem', 'job': 'developer'}))),
        // ),
        offlinePolicyAction: OfflinePolicyAction.retry(retries: 3, retryInterval: Duration(seconds: 4)),
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );
    print("result in main: ${result?.statusCode}  statusMessage ${result
        ?.statusMessage} data: ${result?.data}");
  }

  Future<void> handlePut() async {
    final netraClient = NetraClient(
        baseUrl: "https://jsonplaceholder.typicode.com",
        converterType: ConverterType.kotlinX);

    final result = await netraClient.put(
      // body: RequestBody.createJson(jsonEncode({'name': 'Sinem', 'job': 'developer'})),
      requestOptions: RequestOptions(
        url: "/users/1",
        body: RequestBody.createBytes(Uint8List.fromList(
            utf8.encode(
                jsonEncode({'name': 'Sinem', 'job': 'mobile developer'}))),
        ),
        offlinePolicyAction: OfflinePolicyAction.retry(retries: 3, retryInterval: Duration(seconds: 4)),
        slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
      ),
    );
    print("result in main: ${result?.statusCode}  statusMessage ${result
        ?.statusMessage} data: ${result?.data}");
  }

  Future<void> handleDelete() async {
    final netraClient = NetraClient(
        baseUrl: "https://jsonplaceholder.typicode.com",
        converterType: ConverterType.kotlinX);

    final result = await netraClient.delete(
      requestOptions: RequestOptions(
          url: "/users/1",
          offlinePolicyAction: OfflinePolicyAction.retry(retries: 3, retryInterval: Duration(seconds: 4)),
          slowNetworkPolicyAction: SlowNetworkPolicyAction.wait(delay: 2),
          headers: {
            "custom": "sinem here",
          }
      ),
    );
    print("result in main:  headers: ${jsonEncode(
        result?.headers)}  statusMessage ${result
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
      final netraClient = await NetraClient(
          baseUrl: "http://10.0.2.2:3001",
          converterType: ConverterType.kotlinX);

      final requestBodyPart = RequestBodyPart.file(name: "image",
          fileName: "exampleImage",
          bytes: bytes,
          contentType: "image/jpeg");
      final requestBody = RequestBody.multipart([requestBodyPart]);

      final result = await netraClient.post(
        requestOptions: RequestOptions(
          url: "/upload",
          body: requestBody,
          offlinePolicyAction: OfflinePolicyAction.retry(retries: 3, retryInterval: Duration(seconds: 4)),
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
            children: [
              ElevatedButton(onPressed: handleGet, child: Text('get',)),
              ElevatedButton(
                  onPressed: handleGetImage, child: Text('get image',)),
              ElevatedButton(onPressed: handlePost, child: Text('post',)),
              ElevatedButton(onPressed: pickImage, child: Text('post image',)),
              ElevatedButton(onPressed: handlePut, child: Text('put',)),
              ElevatedButton(onPressed: handleDelete, child: Text('delete',)),
              StreamBuilder<Uint8List>(
                stream: imageStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      gaplessPlayback: true, // Prevents flickering when the stream updates
                    );
                  }

                  return const Icon(Icons.error);
                },
              ),
            ]
        ),
      ),
    );
  }
}
