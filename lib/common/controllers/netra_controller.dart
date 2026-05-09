import 'dart:convert';

import 'package:netra_flutter/common/dto/request_body_dto.dart';
import 'package:netra_flutter/common/dto/response_dto.dart';
import 'package:netra_flutter/common/dto/request_options_dto.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/models/request_body.dart';
import 'package:netra_flutter/common/models/response.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:netra_flutter/pigeons/netra_host_api.g.dart';

class NetraController {
  final _hostApi = NetraHostApi();

  Future<String?> build(
      {required String baseUrl, ConverterType? convertedType}) async {
    String? result;
    try {
      final clientId = await _hostApi.build(baseUrl, convertedType?.identifier);
      result = clientId;
    } catch (e) {
      print("result error: ${e}");
    }
    return result;
  }

  Future<Response?> get(String clientId, String url,
      RequestOptions? requestOptions,) async {
    Response? response;
    try {
      var _requestOptions = requestOptions != null ? jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson()) : null;
      final result = await _hostApi.get(clientId, url, _requestOptions);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } catch (e) {
      print("result error: ${e}");
    }
    return response;
  }

  Future<Response?> post(String clientId,
      String url,
      RequestBody? data,
      RequestOptions? requestOptions,) async {
    Response? response;
    try {
      var requestOptionsJson = requestOptions != null ? jsonEncode(
          RequestOptionsDTO.fromDataModel(requestOptions).toJson()) : null;
      var requestBodyJson = data != null ? jsonEncode(
          RequestBodyDTO.fromDataModel(data).toJson()) : null;
      final result = await _hostApi.post(clientId, url, requestBodyJson, requestOptionsJson);
      if (result != null) {
        response = ResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } catch (e) {
      print("result error: ${e}");
    }
    return response;
  }
}