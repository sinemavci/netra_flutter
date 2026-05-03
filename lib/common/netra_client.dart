import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:netra_flutter/common/enums/converter_type.dart';
import 'package:uuid/uuid.dart';

class NetraClient {
  String id;
  final String baseUrl;
  final ConverterType? converterType;

  NetraClient._create(this.baseUrl, this.converterType) : id = Uuid().v4();

  static Future<NetraClient> build(
      { required String baseUrl, ConverterType? convertedType}) async {
    final clientId = await NetraController().build(baseUrl: baseUrl, convertedType: convertedType);
    var client = NetraClient._create(baseUrl, convertedType);
    if (clientId != null) {
      client.id = clientId;
    }
    return client;
  }

  Future<void> get(String url) async {
    await NetraController().get(id, url);
  }
}