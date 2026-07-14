import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/models/request_body.dart';

part 'request_body_dto.freezed.dart';
part 'request_body_dto.g.dart';

@freezed
abstract class RequestBodyDTO with _$RequestBodyDTO {
  const RequestBodyDTO._();

  const factory RequestBodyDTO({
    required dynamic content,
    required String contentType,
    required bool isMultipart,
    required String type,
  }) = _RequestBodyDTO;

  factory RequestBodyDTO.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyDTOFromJson(json);

  factory RequestBodyDTO.fromDataModel(RequestBody model) {
    var typeResult = 'json';
    if (model.content is Map) {
      typeResult = 'map';
    } else if (model.content is List<int>) {
      typeResult = 'raw';
    }
    return RequestBodyDTO(
      content: model.content,
      contentType: model.contentType,
      isMultipart: model.isMultipart,
      type: typeResult,
    );
  }

  RequestBody toDataModel() {
    if (isMultipart) {
      return RequestBody.multipart(content);
    } else {
      if (type == "map") {
        return RequestBody.createMap(content);
      } else if (type == "raw") {
        return RequestBody.createBytes(content);
      } else {
        return RequestBody.createJson(content);
      }
    }
  }
}
