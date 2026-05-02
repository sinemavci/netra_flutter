import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:uuid/uuid.dart';

class NetraClient {
  final String id;
  final String baseUrl;

  NetraClient(this.baseUrl) : id = Uuid().v4();

  static Future<void> get(String url) async {
    await NetraController().get(url);
  }
}