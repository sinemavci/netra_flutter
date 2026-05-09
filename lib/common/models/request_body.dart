import 'dart:convert';

import 'package:netra_flutter/common/dto/request_body_part_dto.dart';
import 'package:netra_flutter/common/models/request_body_part.dart';

class RequestBody {
  final dynamic content;
  final String contentType;
  final bool isMultipart;

  const RequestBody._({
    required this.content,
    this.contentType = "application/json; charset=utf-8",
    this.isMultipart = false,
  });

  factory RequestBody.createJson(String json, {
    String contentType = "application/json; charset=utf-8",
  }) {
    return RequestBody._(
      content: json,
      contentType: contentType,
    );
  }

  factory RequestBody.createBytes(List<int> bytes, {
    String? contentType,
  }) {
    return RequestBody._(
      content: bytes,
      contentType: contentType ?? "application/json; charset=utf-8",
    );
  }

  factory RequestBody.createMap(Map<String, dynamic> map,) {
    return RequestBody._(
      content: map,
    );
  }

  factory RequestBody.multipart(List<RequestBodyPart> parts,) {
    return RequestBody._(
      content: jsonEncode(parts.map((it) {
        return RequestBodyPartDTO
            .fromDataModel(it).toJson();
      }).toList()),
      contentType: "multipart/form-data",
      isMultipart: true,
    );
  }
}
