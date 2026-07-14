import 'package:netra_flutter/common/models/request_body.dart';

class RequestBodyPart {
  final String name;

  final RequestBody requestBody;

  final String? fileName;

  RequestBodyPart({
    required this.name,
    required this.requestBody,
    this.fileName,
  });

  factory RequestBodyPart.file({
    required String name,
    required String fileName,
    required List<int> bytes,
    String? contentType,
  }) {
    return RequestBodyPart(
      name: name,
      fileName: fileName,
      requestBody: RequestBody.createBytes(bytes, contentType: contentType),
    );
  }

  factory RequestBodyPart.formData({
    required String name,
    required String value,
  }) {
    return RequestBodyPart(
      name: name,
      fileName: null,
      requestBody: RequestBody.createJson(value, contentType: "text/plain"),
    );
  }
}
