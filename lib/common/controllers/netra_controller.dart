import 'dart:convert';

import 'package:netra_flutter/common/dto/netra_response_dto.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/common/models/netra_response.dart';
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

  Future<NetraResponse?> get(String clientId, String url) async {
    NetraResponse? response;
    try {
      final result = await _hostApi.get(clientId, url);
      if (result != null) {
        response = NetraResponseDTO.fromJson(json.decode(result)).toDataModel();
      }
    } catch (e) {
      print("result error: ${e}");
    }
    return response;
  }
}