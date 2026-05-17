import 'dart:convert';

import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/models/circuit_breaker_options.dart';
import 'package:netra_flutter/common/models/request_body.dart';
import 'package:netra_flutter/common/models/response.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/observers/client_observer.dart';
import 'package:netra_flutter/common/observers/client_event.dart';
import 'package:uuid/uuid.dart';

class NetraClient {
  String id;
  final String baseUrl;
  final ConverterType? converterType;

  late final ClientObserver observer;
  final controller = NetraController();

  NetraClient._create(this.baseUrl, this.converterType) : id = Uuid().v4();

  static Future<NetraClient> build({
    required String baseUrl,
    Map<String, String>? headers,
    ConverterType? convertedType,
    CircuitBreakerOptions? circuitBreakerOptions,
  }) async {
    final clientId = await NetraController().build(
      baseUrl: baseUrl,
      convertedType: convertedType,
      headers: headers,
      circuitBreakerOptions: circuitBreakerOptions,
    );
    var client = NetraClient._create(baseUrl, convertedType);
    if (clientId != null) {
      client.id = clientId;
      client.observer = ClientObserver(
        clientId: clientId,
      );
    }
    return client;
  }

  Future<Response?> get(
      {required String url, RequestOptions? requestOptions}) async {
    final response = await controller.get(id, url, requestOptions);
    return response;
  }

  Future<Response?> post({
    required String url,
    required RequestBody? body,
    RequestOptions? requestOptions,
  }) async {
    final response = await controller.post(
        id, url, body, requestOptions);
    return response;
  }

  Future<Response?> put({
    required String url,
    required RequestBody? body,
    RequestOptions? requestOptions,
  }) async {
    final response = await controller.put(
        id, url, body, requestOptions);
    return response;
  }

  Future<Response?> patch({
    required String url,
    required RequestBody? body,
    RequestOptions? requestOptions,
  }) async {
    final response = await controller.patch(
        id, url, body, requestOptions);
    return response;
  }

  Future<Response?> delete({
    required String url,
    RequestBody? body,
    RequestOptions? requestOptions,
  }) async {
    final response = await controller.delete(
        id, url, body, requestOptions);
    return response;
  }

  String on(ClientEvent eventName) {
    String eventId = const Uuid().v4().toString();
    observer.on(eventName, eventId);
    controller.on(id, eventName.eventName, eventId);
    return eventId;
  }

  void off(String eventId) {
    observer.off(eventId);
    controller.off(id, eventId);
  }
}