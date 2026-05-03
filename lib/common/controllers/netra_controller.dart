import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:netra_flutter/pigeons/netra_host_api.g.dart';

class NetraController {
  final _hostApi = NetraHostApi();

  Future<String?> build({required String baseUrl, ConverterType? convertedType}) async {
    String? result;
    try {
      final clientId = await _hostApi.build(baseUrl, convertedType?.identifier);
      result = clientId;
    } catch (e) {
      print("result error: ${e}");
    }
    return result;
  }

  Future<void> get(String clientId, String url) async {
    try {
      final result = await _hostApi.get(clientId, url);
    } catch(e) {
      print("result error: ${e}");
    }
  }
}