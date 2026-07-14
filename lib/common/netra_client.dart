import 'dart:async';

import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/models/circuit_breaker_options.dart';
import 'package:netra_flutter/common/models/response.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/common/observers/client_observer.dart';
import 'package:netra_flutter/common/observers/client_event.dart';
import 'package:uuid/uuid.dart';

class NetraClient {
  late String id;
  String baseUrl;
  ConverterType? converterType;
  Map<String, String>? headers;
  CircuitBreakerOptions? circuitBreakerOptions;

  late final ClientObserver observer;
  final controller = NetraController();

  final Completer<void> _initCompleter = Completer<void>();

  NetraClient({
    required this.baseUrl,
    this.headers,
    this.converterType,
    this.circuitBreakerOptions,
  }) {
    id = const Uuid().v4();
    _initializeNetraClient();
  }

  Future<void> _initializeNetraClient() async {
    try {
      final clientId = await controller.build(
        baseUrl: baseUrl,
        convertedType: converterType,
        headers: headers,
        circuitBreakerOptions: circuitBreakerOptions,
      );

      if (clientId != null) {
        id = clientId;
        observer = ClientObserver(clientId: clientId);
      }

      _initCompleter.complete();
    } catch (e, stackTrace) {
      _initCompleter.completeError(e, stackTrace);
    }
  }

  Future<void> _ensureInitialized() async {
    return _initCompleter.future;
  }

  Future<Response?> get({required RequestOptions requestOptions}) async {
    await _ensureInitialized();
    final response = await controller.get(id, requestOptions);
    return response;
  }

  Future<Stream<List<int>>> getStream({
    required RequestOptions requestOptions,
  }) async {
    await _ensureInitialized();
    final response = await controller.getStream(id, requestOptions);
    return response;
  }

  Future<Response?> post({required RequestOptions requestOptions}) async {
    await _ensureInitialized();
    final response = await controller.post(id, requestOptions);
    return response;
  }

  Future<Response?> put({required RequestOptions requestOptions}) async {
    await _ensureInitialized();
    final response = await controller.put(id, requestOptions);
    return response;
  }

  Future<Response?> patch({required RequestOptions requestOptions}) async {
    await _ensureInitialized();
    final response = await controller.patch(id, requestOptions);
    return response;
  }

  Future<Response?> delete({required RequestOptions requestOptions}) async {
    await _ensureInitialized();
    final response = await controller.delete(id, requestOptions);
    return response;
  }

  String on(ClientEvent eventName) {
    String eventId = const Uuid().v4().toString();

    _ensureInitialized().then((_) {
      observer.on(eventName, eventId);
      controller.on(id, eventName.eventName, eventId);
    });
    return eventId;
  }

  void off(String eventId) {
    _ensureInitialized().then((_) {
      observer.off(eventId);
      controller.off(id, eventId);
    });
  }
}
