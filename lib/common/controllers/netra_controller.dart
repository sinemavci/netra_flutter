import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:netra_flutter/common/dto/circuit_breaker_options_dto.dart';
import 'package:netra_flutter/common/dto/response_dto.dart';
import 'package:netra_flutter/common/dto/request_options_dto.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/exceptions/base_platform_exception.dart';
import 'package:netra_flutter/common/exceptions/exception_manager.dart';
import 'package:netra_flutter/common/models/circuit_breaker_options.dart';
import 'package:netra_flutter/common/models/response.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/pigeons/netra_host_api.g.dart';

class NetraController {

  final _hostApi = NetraHostApi();

  Future<String?> build({
    required String baseUrl,
    ConverterType? convertedType,
    Map<String, String>? headers,
    CircuitBreakerOptions? circuitBreakerOptions,
  }) async {
    String? result;
    try {
      var _circuitBreakerOptions = circuitBreakerOptions != null ? jsonEncode(
          CircuitBreakerOptionsDTO
              .fromDataModel(circuitBreakerOptions)
              .toJson()) : null;
      final clientId = await _hostApi.build(
          baseUrl, convertedType?.identifier, headers, _circuitBreakerOptions);
      result = clientId;
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return result;
  }

  Future<Response?> get(String clientId, RequestOptions requestOptions) async {
    Response? response;
    try {
      var _requestOptions = jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson());
      final result = await _hostApi.get(clientId, _requestOptions);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return response;
  }

  Future<Stream<List<int>>> getStream(String clientId,
      RequestOptions requestOptions,) async {
    final controller = StreamController<List<int>>();
    await _hostApi.registerStream(requestOptions.id!);
    var _requestOptions = jsonEncode(
        RequestOptionsDTO.fromDataModel(requestOptions).toJson());
    final EventChannel _eventChannel = EventChannel(
        "StreamResponseListener${requestOptions.id}");
    _eventChannel.receiveBroadcastStream().listen((data) {
      if (data is List<int>) {
        controller.add(data);
      } else {
        controller.close();
      }
    }, onDone: () {
      controller.close();
    }, onError: (error) {
      print("onError: ${error}");
    });

    _hostApi.stream(clientId, _requestOptions);
    return controller.stream;
  }

  Future<Response?> post(String clientId, RequestOptions requestOptions) async {
    Response? response;
    try {
      var requestOptionsJson = jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson());
      final result = await _hostApi.post(clientId, requestOptionsJson);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return response;
  }

  Future<Response?> put(String clientId, RequestOptions requestOptions) async {
    Response? response;
    try {
      var requestOptionsJson = jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson());
      final result = await _hostApi.put(clientId, requestOptionsJson);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return response;
  }

  Future<Response?> patch(String clientId, RequestOptions requestOptions) async {
    Response? response;
    try {
      var requestOptionsJson = jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson());
      final result = await _hostApi.patch(clientId, requestOptionsJson);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return response;
  }

  Future<Response?> delete(String clientId, RequestOptions requestOptions) async {
    Response? response;
    try {
      var requestOptionsJson = jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson());
      final result = await _hostApi.delete(clientId, requestOptionsJson);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } on PlatformException catch (e) {
      throw ExceptionManager.parse(e);
    }
    return response;
  }

  Future<void> on(String clientId, String eventName, String eventId) async {
    try {
      await _hostApi.on(clientId, eventName, eventId);
    } on PlatformException catch (e) {
      rethrow;
    }
  }

  Future<void> off(String clientId, String eventId) async {
    try {
      await _hostApi.off(clientId, eventId);
    } on PlatformException catch (e) {
      rethrow;
    }
  }
}