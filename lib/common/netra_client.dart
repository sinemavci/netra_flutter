import 'dart:convert';

import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/models/request_body.dart';
import 'package:netra_flutter/common/models/response.dart';
import 'package:netra_flutter/common/models/request_options.dart';
import 'package:uuid/uuid.dart';

class NetraClient {
  String id;
  final String baseUrl;
  final ConverterType? converterType;

  NetraClient._create(this.baseUrl, this.converterType) : id = Uuid().v4();

  static Future<NetraClient> build(
      { required String baseUrl, ConverterType? convertedType}) async {
    final clientId = await NetraController().build(
        baseUrl: baseUrl, convertedType: convertedType);
    var client = NetraClient._create(baseUrl, convertedType);
    if (clientId != null) {
      client.id = clientId;
    }
    return client;
  }

  Future<Response?> get(
      {required String url, RequestOptions? requestOptions}) async {
    final response = await NetraController().get(id, url, requestOptions);
    return response;
  }

  Future<Response?> post({
    required String url,
    required RequestBody? body,
    RequestOptions? requestOptions,
  }) async {
    final response = await NetraController().post(
        id, url, body, requestOptions);
    return response;
  }
}