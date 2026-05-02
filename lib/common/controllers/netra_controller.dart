import 'package:netra_flutter/pigeons/netra_host_api.g.dart';

class NetraController {
  final _hostApi = NetraHostApi();

  Future<void> get(String url) async {
    try {
      final result = await _hostApi.get(url);
      print("result: ${result}");
    } catch(e) {
      print("result error: ${e}");
    }
  }
}